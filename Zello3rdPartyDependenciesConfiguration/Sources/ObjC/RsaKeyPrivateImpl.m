@import Foundation;
@import OpenSSL;

#import "RsaKeyPrivateImpl.h"
#import "NSString+Utility.h"

static NSString *PRIVATE_HEADER = @"-----BEGIN RSA PRIVATE KEY-----\n";
static NSString *PRIVATE_FOOTER = @"\n-----END RSA PRIVATE KEY-----";


@interface RsaKeyPrivateImpl ()
@property (atomic) RSA *privatekey;
@property (atomic) BOOL keyPassedIn;
@end

@implementation RsaKeyPrivateImpl

- (instancetype)init {
  return [super init];
}

- (instancetype)initWithKey:(RSA *)key {
  self = [super init];
  if (self) {
    self.privatekey = key;
  }
  return self;
}

- (NSString *)sign:(NSData *)data {
  NSString *signString = nil;
  if (!self.privatekey) {
    return signString;
  }
  NSData *encodeBlock = nil;

  MD5_CTX hash;
  unsigned char md[16];
  MD5_Init(&hash);
  MD5_Update(&hash, [data bytes], data.length);
  MD5_Final(md, &hash);
  NSMutableData *sign = [[NSMutableData alloc] initWithLength:RSA_size(self.privatekey) * 2];

  unsigned int len;
  if (!RSA_sign(NID_md5, md, sizeof md, (unsigned char *)[sign mutableBytes], &len, self.privatekey) || len > sign.length) {
    return nil;
  }
  NSMutableData *base64 = [[NSMutableData alloc]initWithLength:len / 3 * 4 + (len % 3 ? 4 : 0) + 1];
  int encodeLen = EVP_EncodeBlock([base64 mutableBytes], [sign mutableBytes], len);
  encodeBlock = [base64 subdataWithRange:NSMakeRange(0, encodeLen)];

  return [self fromUtf8:encodeBlock];
}

- (NSData *)decrypt:(NSData *)data {
  NSMutableData *dataTo = [[NSMutableData alloc] initWithLength:data.length * 4];
  Byte *ptrFrom = (Byte *)[data bytes];
  Byte *ptrTo = [dataTo mutableBytes];
  int res = RSA_private_decrypt((int32_t)data.length, ptrFrom, ptrTo, self.privatekey, RSA_PKCS1_PADDING);
  if (res <= 0) {
    return nil;
  }
  return [dataTo subdataWithRange:NSMakeRange(0, res)];
}

- (NSString *)fromUtf8:(NSData *)data {
  if (data != nil) {
    NSString *result =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if ([self isNullOrEmpty:result]) {
      result =  [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    }
    return result;
  }
  return nil;
}

- (BOOL)isNullOrEmpty:(NSString *)target {
  return (NSNull *)target == [NSNull null] || target == nil || ([target isKindOfClass:[NSString class]] && [target length] == 0);
}

- (NSString *)serialize {
  if (!self.privatekey) {
    return nil;
  }
  NSString *resString = nil;

  char *res = nil;
  BIO *bio = BIO_new(BIO_s_mem());
  if (PEM_write_bio_RSAPrivateKey(bio, self.privatekey, 0, 0, 0, 0, 0) > 0) {
    res = malloc(BIO_number_written(bio) + 1);
    memset(res, 0, BIO_number_written(bio) + 1);
    BIO_read(bio, &res[0], (int)BIO_number_written(bio));
  }
  if (res) {
    resString = [[NSString alloc] initWithCString:res encoding:NSASCIIStringEncoding];
    free(res);
  }
  BIO_free_all(bio);

  if (resString) {
    return [self pureData:resString];
  } else {
    return nil;
  }
}

- (BOOL)deserialize:(NSString *)s {
  if (self.privatekey) {
    [self reset];
  }

  BIO *bio = BIO_new(BIO_s_mem());
  BIO_write(bio, [PRIVATE_HEADER cStringUsingEncoding:NSASCIIStringEncoding], (int)PRIVATE_HEADER.length);
  [self writeOpenSSLString:bio withChar:[s UTF8String] andLength:(int32_t)s.length];
  BIO_write(bio, [PRIVATE_FOOTER cStringUsingEncoding:NSASCIIStringEncoding], (int)PRIVATE_FOOTER.length);
  self.privatekey = PEM_read_bio_RSAPrivateKey(bio, 0, 0, 0);
  BIO_free_all(bio);

  if (self.privatekey) {
    self.keyPassedIn = NO; // if this key was passed in we just recreated it new.
  }
  return self.privatekey != 0;
}

- (NSString *)pureData:(NSString *)key {
  NSString *pureData;
  NSString *data;
  NSInteger begin = [key indexOf:PRIVATE_HEADER] + PRIVATE_HEADER.length;

  data = [key substringFromIndex:begin];
  NSInteger end = [data indexOf:PRIVATE_FOOTER];
  if (end != -1) {
    data = [data substringToIndex:end];
  } else {
    NSLog(@"PRIVATE_FOOTER not found! %@", data);
  }
  data = [data stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  pureData = [[NSString alloc] initWithFormat:@"%@", data];
  return pureData;
}

- (void)reset {
  if (self.privatekey /*&& !self.keyPassedIn*/) {
    RSA_free(self.privatekey);
    self.privatekey = nil;
  }
}

- (void)writeOpenSSLString:(BIO *)bio withChar:(const char *)str andLength:(unsigned)len {
  static const unsigned nBlock = 64;
  unsigned nWritten = 0;
  unsigned nLen = 0;

  while (nWritten < len) {
    nLen = MIN(nBlock, len - nWritten);
    BIO_write(bio, str + nWritten, nLen);
    nWritten += nLen;
    if (nLen == nBlock && nWritten != len) {
      BIO_write(bio, "\n", 1);
    }
    while (nWritten < len && str[nWritten] && (str[nWritten] == '\n' || str[nWritten] == '\r')) {
      ++nWritten;
    }
  }
}
@end
