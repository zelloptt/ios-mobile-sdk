@import OpenSSL;

#import "DecipherImpl.h"

@interface DecipherImpl () {
  AES_KEY aesKey;
  unsigned char sz[AES_BLOCK_SIZE];
}

@end

@implementation DecipherImpl

- (nullable instancetype)initWithKey:(id<AesKey>)key {
  self = [super init];
  if (self) {
    NSData *keyData = [key getKeyData];

    if (!keyData || keyData.length == 0) {
      return nil;
    }

    Byte *keyPtr = (Byte *)[keyData bytes];
    int result = AES_set_decrypt_key(keyPtr, (int32_t)keyData.length * 8, &aesKey);

    if (result != 0) {
      return nil;
    }
  }
  return self;
}


- (NSData *)decode:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length {
  if (![data isKindOfClass:[NSData class]] || length <= 0 || offset < 0 || (offset + length > [data length])) {
    return nil;
  }
  NSMutableData *dataOut = nil;
  Byte *dataInPtr = (Byte *)[data bytes];
  int byte0 = dataInPtr[0];
  int byte1 = dataInPtr[1];
  int decodedSize = (byte0 & 0xFF) + ((byte1 & 0xFF) << 8);
  if (decodedSize > 0 && decodedSize <= length - 2) {
    dataOut = [[NSMutableData alloc] initWithLength:decodedSize];
    Byte *dataOutPtr = [dataOut mutableBytes];

    for (int i = 0; i < decodedSize; i += AES_BLOCK_SIZE) {
      if (i + AES_BLOCK_SIZE > decodedSize) {
        AES_decrypt(dataInPtr + offset + i + 2, sz, &aesKey);
        memcpy(dataOutPtr + i, sz, decodedSize - i);
        break;
      }
      AES_decrypt(dataInPtr + offset + i + 2, dataOutPtr + i, &aesKey);
    }
  }
  return dataOut;
}

@end
