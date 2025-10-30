@import OpenSSL;

#import "EncipherImpl.h"

@interface EncipherImpl () {
  AES_KEY aesKey;
  unsigned char sz[AES_BLOCK_SIZE];
}
@end

@implementation EncipherImpl

- (void)setKey:(id<AesKey>)keyIn {
  Byte *keyPtr = (Byte *)[[keyIn getKeyData] bytes];
  AES_set_encrypt_key(keyPtr, (int32_t)[keyIn getKeyData].length * 8, &aesKey);
}

- (NSData *)encode:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length {
  if (![data isKindOfClass:[NSData class]] || length <= 0 || offset < 0 || offset + length > data.length) {
    return nil;
  }

  NSMutableData *dataOut = [[NSMutableData alloc] initWithLength:length];
  NSInteger outputSize = length + ((AES_BLOCK_SIZE - ((int32_t)length % AES_BLOCK_SIZE)) % AES_BLOCK_SIZE);
  [dataOut setLength:outputSize + 2];
  Byte *dataOutPtr = [dataOut mutableBytes];
  Byte *dataInPtr = (Byte *)[data bytes];

  for (unsigned i = 0; i < outputSize; i += AES_BLOCK_SIZE) {
    if (i + AES_BLOCK_SIZE > length) {
      memset(sz, 0, AES_BLOCK_SIZE);
      memcpy(sz, dataInPtr + i, length - i);
      AES_encrypt(sz, dataOutPtr + i + 2, &aesKey);
      break;
    }
    AES_encrypt(dataInPtr + offset + i, dataOutPtr + i + 2, &aesKey);
  }

  Byte b0 = (Byte)(length & 0xFF);
  Byte b1 = (Byte)((length & 0xFF00) >> 8);
  *((Byte *)dataOutPtr) = b0;
  *((Byte *)dataOutPtr + 1) = b1;

  return dataOut;
}

@end
