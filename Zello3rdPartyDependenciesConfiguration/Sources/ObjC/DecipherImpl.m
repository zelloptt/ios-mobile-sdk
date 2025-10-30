@import OpenSSL;

#import "DecipherImpl.h"

@interface DecipherImpl () {
  AES_KEY aesKey;
  unsigned char sz[AES_BLOCK_SIZE];
}

@end

@implementation DecipherImpl

- (void)setKey:(id<AesKey>)keyIn {
  Byte *keyPtr = (Byte *)[[keyIn getKeyData] bytes];
  AES_set_decrypt_key(keyPtr, (int32_t)[keyIn getKeyData].length * 8, &aesKey);
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
