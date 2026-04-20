#import <Utility/Utility.h>

@class NetworkAddress;

@interface ZAsyncSocketImpl : NSObject <UnifiedTCPSocket>

@property (nonatomic, weak, readwrite) id<UnifiedTCPSocketDelegate> delegate;
@property (nonatomic, readonly) BOOL isSecure;

#pragma mark Initialization
- (id)init;
- (id)initWithDelegate:(id)delegate;

#pragma mark Conneting and disconnecting
- (BOOL)connectTo:(NetworkAddress *)addr error:(NSError *__autoreleasing *)errPtr;
- (BOOL)connectTo:(NetworkAddress *)addr withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr;
- (void)disconnect;

#pragma mark Asynchronous operations
- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag;

#pragma mark Synchronous operations
- (NSInteger)syncRead:(NSMutableData *)data maxLength:(NSInteger)length;
- (NSInteger)syncRead:(NSMutableData *)data maxLength:(NSInteger)length withTimeout:(NSTimeInterval)timeout;

#pragma mark Configuration
- (void)enableVoiceTrafficClass:(BOOL)enable;
- (void)enableVoIP;

@end
