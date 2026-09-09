@import OpenSSL;
#if ZELLO_LOCAL_SPM
@import ZelloSecureObjC;
#else
@import ZelloSecure;
#endif

#import "AesKeyImpl.h"

@interface AesKeyImpl ()
@property (atomic, strong) NSData *dataKey;
@end

@implementation AesKeyImpl

- (nullable instancetype)initWithDataKey:(NSData *)dataKeyIn {
    self = [super init];
    if (self) {
        NSUInteger len = dataKeyIn.length;
        if (len != 16 && len != 24 && len != 32) {
            return nil;
        }

        self.dataKey = dataKeyIn;
    }
    return self;
}

- (NSData *)encrypt:(NSData *)dataIn {
    return [self encrypt:dataIn withOffset:0 andLength:dataIn.length];
}

- (NSData *)encrypt:(NSData *)dataIn withOffset:(NSInteger)offset andLength:(NSInteger)length {
    if (!self.dataKey || !dataIn || offset < 0 || length < 1 || (offset + length) > dataIn.length) {
        return nil;
    }
    NSMutableData *dataOut = nil;

    AES_KEY key;
    Byte *dataInPtr = (Byte *)[dataIn bytes];
    Byte *keyPtr = (Byte *)[self.dataKey bytes];

    if (AES_set_encrypt_key(keyPtr, (int32_t)self.dataKey.length * 8, &key) != 0) {
        return nil;
    }
    NSInteger outputSize = length + ((AES_BLOCK_SIZE - (length % AES_BLOCK_SIZE)) % AES_BLOCK_SIZE);

    dataOut = [[NSMutableData alloc] initWithLength:outputSize];
    Byte *dataOutPtr = [dataOut mutableBytes];

    for (unsigned i = 0; i < outputSize; i += AES_BLOCK_SIZE) {
        if (i + AES_BLOCK_SIZE > length) {
            unsigned char sz[AES_BLOCK_SIZE] = {0};
            memcpy(sz, dataInPtr + offset + i, length - i);
            AES_encrypt(sz, dataOutPtr + i, &key);
            break;
        }
        AES_encrypt(dataInPtr + offset + i, dataOutPtr + i, &key);
    }

    return dataOut;
}

- (NSData *)decrypt:(NSData *)dataIn withOffset:(NSInteger)offset andLength:(NSInteger)length {
    if (!dataIn || !self.dataKey || offset < 0 || length < 1 || (offset + length) > (NSInteger)dataIn.length) {
        return nil;
    }
    NSMutableData *dataOut = [[NSMutableData alloc] initWithLength:length];
    AES_KEY key;
    Byte *dataOutPtr = [dataOut mutableBytes];
    Byte *dataInPtr = (Byte *)[dataIn bytes];
    Byte *keyPtr = (Byte *)[self.dataKey bytes];

    if (AES_set_decrypt_key(keyPtr, (int32_t)self.dataKey.length * 8, &key) != 0) {
        return nil;
    }
    for (int i = 0; i < length; i += AES_BLOCK_SIZE) {
        AES_decrypt(dataInPtr + offset + i, dataOutPtr + i, &key);
    }
    return dataOut;
}

- (NSData *)getKeyData {
    return self.dataKey;
}

- (BOOL)isValid {
    return self.dataKey != nil;
}
@end
