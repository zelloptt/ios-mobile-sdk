@import Darwin.POSIX.netinet.in;
@import Darwin.POSIX.netinet.tcp;
#import <Utility/Utility.h>
#import <ZelloSecure/ZelloSecure.h>
#if __has_include(<CocoaAsyncSocket/GCDAsyncSocket.h>)
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#else
@import CocoaAsyncSocket;
#endif

#import "ZAsyncSocketImpl.h"

@interface Synchronizer : NSObject {
    NSMutableDictionary *_locks;
    NSMutableDictionary *_flags;
    NSMutableDictionary *_results;
    long _index;
}
- (id)init;
- (NSNumber *)nextTag;
- (void)wait:(NSNumber *)tag;
- (void)signal:(NSNumber *)tag;
- (void)signal:(NSNumber *)tag withResult:(id)result;
- (void)signalAll;
- (id)getResult:(NSNumber *)tag;
- (void)releaseTag:(NSNumber *)tag;
@end

@implementation Synchronizer

- (id)init {
    if (self = [super init]) {
        _locks = [NSMutableDictionary dictionaryWithCapacity:3];
        _flags = [NSMutableDictionary dictionaryWithCapacity:3];
        _results = [NSMutableDictionary dictionaryWithCapacity:3];
        _index = 10000;
    }
    return self;
}

- (void)dealloc {
    [_locks removeAllObjects];
    _locks = nil;

    [_flags removeAllObjects];
    _flags = nil;

    [_results removeAllObjects];
    _results = nil;
}

// sync
- (NSNumber *)nextTag {
    NSNumber *nextKey = [NSNumber numberWithLong:++_index];

    [_locks setObject:[[NSCondition alloc] init] forKey:nextKey];
    [_flags setObject:[NSNumber numberWithBool:YES] forKey:nextKey];
    return nextKey;
}

- (void)wait:(NSNumber *)tag {
    NSCondition *lock = (NSCondition *)[_locks objectForKey:tag];

    if (lock) {
        [lock lock];
        while ([(NSNumber *)[_flags objectForKey:tag] boolValue] == YES) {
            [lock wait];
        }
        [lock unlock];
    }
}

- (void)signal:(NSNumber *)tag {
    [self signal:tag withResult:nil];
}

- (void)signal:(NSNumber *)tag withResult:(id)result {
    NSCondition *lock = (NSCondition *)[_locks objectForKey:tag];

    if (lock && [lock isKindOfClass:[NSCondition class]]) {
        [lock lock];
        [_flags setObject:[NSNumber numberWithBool:NO] forKey:tag];
        if (result) {
            [_results setObject:result forKey:tag];
        }
        [lock signal];
        [lock unlock];
    }
}

- (id)getResult:(NSNumber *)tag {
    return [_results objectForKey:tag];
}

// sync
- (void)signalAll {
    NSEnumerator *keys = [_locks keyEnumerator];
    id key;

    while (key = [keys nextObject]) {
        [self signal:key];
    }
}

// sync
- (void)releaseTag:(NSNumber *)tag {
    [_locks removeObjectForKey:tag];
    [_flags removeObjectForKey:tag];
    [_results removeObjectForKey:tag];
}

@end

@interface ZAsyncSocketImpl () <UnifiedTCPSocket, GCDAsyncSocketDelegate> {
    ZelloTrustManager *_tm;
    GCDAsyncSocket *_socket;
    NetworkAddress *_remoteAddr;

    id __weak _delegate;
    BOOL _voip;
    BOOL _enableIPQoS;

    NSNumber *_connectTag;

    BOOL _connected;

    Synchronizer *_syncho;
    NSMutableData *_overreadBuf;
}
@property QueueRunner *runner;
@end

@implementation ZAsyncSocketImpl

#pragma mark Initialization
- (id)init {
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id)delegateIn {
    if ((self = [super init])) {
        _syncho = [[Synchronizer alloc] init];
        _overreadBuf = [NSMutableData data];
        _delegate = delegateIn;
        self.runner = [[QueueRunner alloc] init];

        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.runner.queue];
        [_socket setIPv4PreferredOverIPv6:NO];
        _voip = NO;
    }
    return self;
}

- (void)dealloc {
    _delegate = nil;
    _socket.delegate = nil;
    _socket = nil;
    _tm = nil;
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}

- (id)delegate {
    return _delegate;
}

- (BOOL)isSecure {
    return [_socket isSecure];
}

/**
 * Runs the block synchronously in our delegate queue -- we use it to avoid
 * concurrency issues accessing Synchronizer
 */
- (void)performBlock:(dispatch_block_t)block {
    [self.runner runSync:block];
}

#pragma mark Conneting and disconnecting
- (BOOL)connectTo:(NetworkAddress *)addr error:(NSError *__autoreleasing *)errPtr {
    _remoteAddr = addr;
    _tm = [[ZelloTrustManager alloc] initWithAllowedCN:addr.tlsRealm];

    [self performBlock:^{ self->_connectTag = [self->_syncho nextTag]; }];

    BOOL res = [_socket connectToHost:addr.host onPort:addr.port error:errPtr];
    if (res) {
        [self->_syncho wait:_connectTag];
        [self performBlock:^{ [self->_syncho releaseTag:self->_connectTag]; }];
    }
    return _connected;
}

- (BOOL)connectTo:(NetworkAddress *)addr withTimeout:(NSTimeInterval)timeout error:(NSError *__autoreleasing *)errPtr {
    _remoteAddr = addr;
    _tm = [[ZelloTrustManager alloc] initWithAllowedCN:addr.tlsRealm];

    [self performBlock:^{ self->_connectTag = [self->_syncho nextTag]; }];

    BOOL res = [_socket connectToHost:addr.host onPort:addr.port withTimeout:timeout error:errPtr];
    if (res) {
        [self->_syncho wait:_connectTag];
        [self performBlock:^{ [self->_syncho releaseTag:self->_connectTag]; }];
    }
    return _connected;
}

- (void)disconnect {
    [_socket disconnect];
}

#pragma mark Asynchronous operations
- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag {
    [_socket writeData:data withTimeout:timeout tag:tag];
}

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag {
    [_socket readDataWithTimeout:timeout tag:tag];
}

#pragma mark Synchronous operations
- (NSInteger)syncRead:(NSMutableData *)data maxLength:(NSInteger)length {
    return [self syncRead:data maxLength:length withTimeout:20.0];
}

- (NSInteger)syncRead:(NSMutableData *)data maxLength:(NSInteger)length withTimeout:(NSTimeInterval)timeout {
    if (![_socket isConnected]) {
        return -1;
    }
    __block NSNumber *tag = nil;
    [self performBlock:^{ tag = [self->_syncho nextTag]; }];
    if (length < 0) {
        length = 0;
    }
    [self->_socket readDataWithTimeout:timeout buffer:data bufferOffset:0 maxLength:length tag:[tag longValue]];
    [self->_syncho wait:tag];

    NSInteger result = -1;
    NSNumber *bytesRead = (NSNumber *)[_syncho getResult:tag];
    [self performBlock:^{ [self->_syncho releaseTag:tag]; }];

    if (bytesRead != nil) {
        result = [bytesRead unsignedIntegerValue];
    } else {
        result = -1; //[data length]; // This usually means connection ended before we read any data
    }
    if (result > length && length > 0) {
        NSLog(@"%@ XXXXXXXXXX Read data overflow: %lu > %ld", _remoteAddr, (unsigned long)result, (long)length);
        result = length;
    }

    return result;
}

#pragma mark Configuration
- (void)enableVoiceTrafficClass:(BOOL)enable {
    [_socket performBlock:^{
        self->_enableIPQoS = enable;
        if (self->_socket.isConnected && self->_socket.isIPv4) {
            CFSocketNativeHandle theNativeSocket = self->_socket.socket4FD;

            int tos_voice = enable ? 184 : 0;

            if (setsockopt(theNativeSocket, IPPROTO_IP, IP_TOS, &tos_voice, sizeof(tos_voice))) {
                NSLog(@"TCP socket error at socket IP_TOS option: %d", errno);
            } else {
                int tos = 0;
                uint toslen = sizeof(tos);

                if (getsockopt(theNativeSocket, IPPROTO_IP, IP_TOS, &tos, &toslen) < 0) {
                    NSLog(@"TCP socket error to get IP_TOS option");
                } else {
                    NSLog(@"TCP socket changing IP_TOS opt = %d\n", tos);
                }
            }
        }
    }];
}

- (void)enableVoIP {
    _voip = YES;
}

#pragma mark GDAsyncSocketDelegeate

/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    ZLogInfo(@"%@ didConnectToHost using %@ %@", _remoteAddr, sock.isIPv6 ? @"IPv6" : @"IPv4",
             _remoteAddr.tls ? @"TLS" : @"");
    if (_voip) {
        [sock performBlock:^{
            const NSInteger set = 1;
            int res = -1;
            if (sock.isIPv6) {
                res = setsockopt(sock.socket6FD, IPPROTO_TCP, TCP_NODELAY, &set, sizeof(set));
            } else if (sock.isIPv4) {
                res = setsockopt(sock.socket4FD, IPPROTO_TCP, TCP_NODELAY, &set, sizeof(set));
            }
            if (res != 0) {
                ZLogError(@"Error setting TCP_NODELAY: %d", res);
            }
        }];
    }

    if (_enableIPQoS) {
        [self enableVoiceTrafficClass:YES];
    }

    if (_remoteAddr.tls) {
        NSDictionary *attributes =
            [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],
                                                                          [NSNumber numberWithBool:NO], nil]
                                        forKeys:[NSArray arrayWithObjects:GCDAsyncSocketManuallyEvaluateTrust,
                                                                          GCDAsyncSocketUseCFStreamForTLS, nil]];
        [_socket startTLS:attributes];
    } else {
        [self signalConnected:YES];
    }
    if ([_delegate respondsToSelector:@selector(socket:didConnectToHost:port:)]) {
        [_delegate socket:self didConnectToHost:host port:port];
    }
}

- (void)signalConnected:(BOOL)success {
    _connected = success;
    [_syncho signal:_connectTag];
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    // ZLogDebug(@"%@ didReadData: %d", _remoteAddr, [data length]);
    [_syncho signal:[NSNumber numberWithLong:tag] withResult:[NSNumber numberWithUnsignedInteger:[data length]]];

    if ([_delegate respondsToSelector:@selector(socket:didRead:withTag:)]) {
        [_delegate socket:self didRead:data withTag:tag];
    } else {
        // ZLogDebug(@"[ZAsync-%@] No delegate %@ didReadData: %ld", self, _remoteAddr, [data length]);
    }
}

/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    // ZLogDebug(@"[ZAsync-%@] didReadPartialDataOfLength: %ld", self, partialLength);
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    // ZLogDebug(@"didWriteDataWithTag");
    [_syncho signal:[NSNumber numberWithLong:tag]];
}

/**
 * Called when a socket has written some data, but has not yet completed the entire write.
 * It may be used to for things such as updating progress bars.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    // ZLogDebug(@"didWritePartialDataOfLength: %d", partialLength);
}

/**
 * Called if a read operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been read so far for the read operation.
 *
 * Note that this method may be called multiple times for a single read if you return positive numbers.
 **/
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock
    shouldTimeoutReadWithTag:(long)tag
                     elapsed:(NSTimeInterval)elapsed
                   bytesDone:(NSUInteger)length {
    // ZLogDebug(@"shouldTimeoutReadWithTag");
    if ([_delegate respondsToSelector:@selector(socket:shouldTimeoutReadWithTag:elapsed:bytesDone:)]) {
        return [_delegate socket:self shouldTimeoutReadWithTag:tag elapsed:elapsed bytesDone:length];
    }
    return 0;
}

/**
 * Called if a write operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been written so far for the write operation.
 *
 * Note that this method may be called multiple times for a single write if you return positive numbers.
 **/
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock
    shouldTimeoutWriteWithTag:(long)tag
                      elapsed:(NSTimeInterval)elapsed
                    bytesDone:(NSUInteger)length {
    // ZLogDebug(@"shouldTimeoutWriteWithTag");
    if ([_delegate respondsToSelector:@selector(socket:shouldTimeoutWriteWithTag:elapsed:bytesDone:)]) {
        return [_delegate socket:self shouldTimeoutWriteWithTag:tag elapsed:elapsed bytesDone:length];
    }
    return 0;
}

/**
 * Conditionally called if the read stream closes, but the write stream may still be writeable.
 *
 * This delegate method is only called if autoDisconnectOnClosedReadStream has been set to NO.
 * See the discussion on the autoDisconnectOnClosedReadStream method for more information.
 **/
- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock {
    // ZLogDebug(@"socketDidCloseReadStream");
}

/**
 * Called when a socket disconnects with or without error.
 *
 * If you call the disconnect method, and the socket wasn't already disconnected,
 * then an invocation of this delegate method will be enqueued on the delegateQueue
 * before the disconnect method returns.
 *
 * Note: If the GCDAsyncSocket instance is deallocated while it is still connected,
 * and the delegate is not also deallocated, then this method will be invoked,
 * but the sock parameter will be nil. (It must necessarily be nil since it is no longer available.)
 * This is a generally rare, but is possible if one writes code like this:
 *
 * asyncSocket = nil; // I'm implicitly disconnecting the socket
 *
 * In this case it may preferrable to nil the delegate beforehand, like this:
 *
 * asyncSocket.delegate = nil; // Don't invoke my delegate method
 * asyncSocket = nil; // I'm implicitly disconnecting the socket
 *
 * Of course, this depends on how your state machine is configured.
 **/
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [self signalConnected:NO];
    [_syncho signalAll];

    if (err.code != 7 && err.code != 0) {
        ZLogError(@"%@ socketDidDisconnect, with error %@", _remoteAddr, [err description]);
    } else {
        ZLogDebug(@"%@ socketDidDisconnect, with no errors", _remoteAddr);
    }

    if ([_delegate respondsToSelector:@selector(socketDidDisconnect:)]) {
        [_delegate socketDidDisconnect:self];
    }
}

/**
 * Called after the socket has successfully completed SSL/TLS negotiation.
 * This method is not called unless you use the provided startTLS method.
 *
 * If a SSL/TLS negotiation fails (invalid certificate, etc) then the socket will immediately close,
 * and the socketDidDisconnect:withError: delegate method will be called with the specific SSL error code.
 **/
- (void)socketDidSecure:(GCDAsyncSocket *)sock {
    // ZLogDebug(@"%@ socketDidSecure", _remoteAddr);

    [self signalConnected:YES];
}

/**
 * Allows a socket delegate to hook into the TLS handshake and manually validate the peer it's connecting to.
 *
 * This is only called if startTLS is invoked with options that include:
 * - GCDAsyncSocketManuallyEvaluateTrust == YES
 *
 * Typically the delegate will use SecTrustEvaluate (and related functions) to properly validate the peer.
 *
 * Note from Apple's documentation:
 *   Because [SecTrustEvaluate] might look on the network for certificates in the certificate chain,
 *   [it] might block while attempting network access. You should never call it from your main thread;
 *   call it only from within a function running on a dispatch queue or on a separate thread.
 *
 * Thus this method uses a completionHandler block rather than a normal return value.
 * The completionHandler block is thread-safe, and may be invoked from a background queue/thread.
 * It is safe to invoke the completionHandler block even if the socket has been closed.
 **/
- (void)socket:(GCDAsyncSocket *)sock
      didReceiveTrust:(SecTrustRef)trust
    completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler {
    // ZLogDebug(@"%@ didReceiveTrust", _remoteAddr);
    if (_tm) {
        completionHandler([_tm checkTrust:trust]);
    }
}

@end

// MARK: - UnifiedTCPSocket Conformance

@implementation ZAsyncSocketImpl (UnifiedTCPSocket)

- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long long)tag {
    [_socket writeData:data withTimeout:timeout tag:(long)tag];
}

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long long)tag {
    [_socket readDataWithTimeout:timeout tag:(long)tag];
}

@end
