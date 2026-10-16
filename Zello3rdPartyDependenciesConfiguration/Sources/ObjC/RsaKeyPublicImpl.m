@import OpenSSL;

#import "RsaKeyPublicImpl.h"
#import "NSString+Utility.h"

static NSString *PUBLIC_HEADER = @"-----BEGIN RSA PUBLIC KEY-----\n";
static NSString *PUBLIC_FOOTER = @"\n-----END RSA PUBLIC KEY-----";

@interface RsaKeyPublicImpl ()
@property (atomic) RSA *rsaKey;
@property (atomic, nullable) NSString *serialized;
@end

@implementation RsaKeyPublicImpl

- (id)initWithKey:(RSA *)initKey {
    self = [super init];
    if (self) {
        if (initKey) {
            RSA_up_ref(initKey);
        }
        _rsaKey = initKey;
    }
    return self;
}

- (void)dealloc {
    if (_rsaKey) {
        RSA_free(_rsaKey);
    }
}

- (NSString *)serialize {
    if (!self.rsaKey) {
        return nil;
    }
    if (self.serialized) {
        return self.serialized;
    }

    NSString *resString = nil;

    char *res = nil;
    BIO *bio = BIO_new(BIO_s_mem());
    if (PEM_write_bio_RSAPublicKey(bio, self.rsaKey) > 0) {
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
        self.serialized = [self pureData:resString];
    }
    return self.serialized;
}

- (BOOL)deserialize:(NSString *)s {
    if (self.rsaKey) {
        [self reset];
    }

    BIO *bio = BIO_new(BIO_s_mem());
    BIO_write(bio, [PUBLIC_HEADER cStringUsingEncoding:NSASCIIStringEncoding], (int)PUBLIC_HEADER.length);
    [self writeOpenSSLString:bio withChar:[s UTF8String] andLength:(int32_t)s.length];
    BIO_write(bio, [PUBLIC_FOOTER cStringUsingEncoding:NSASCIIStringEncoding], (int)PUBLIC_FOOTER.length);
    self.rsaKey = PEM_read_bio_RSAPublicKey(bio, 0, 0, 0);
    BIO_free_all(bio);

    return self.rsaKey != 0;
}

- (NSString *)pureData:(NSString *)key {
    NSString *pureData;
    NSString *data;
    NSInteger begin = [key indexOf:PUBLIC_HEADER] + PUBLIC_HEADER.length;

    data = [key substringFromIndex:begin];
    NSInteger end = [data indexOf:PUBLIC_FOOTER];
    if (end != -1) {
        data = [data substringToIndex:end];
    } else {
        NSLog(@"PUBLIC_FOOTER not found! %@", data);
    }
    data = [data stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    pureData = [[NSString alloc] initWithFormat:@"%@", data];
    return pureData;
}

- (BOOL)isValid {
    return self.rsaKey != nil;
}

- (NSData *)encrypt:(NSData *)data withOaep:(BOOL)oaep {
    if (!self.rsaKey) {
        return nil;
    }
    NSMutableData *encData = nil;

    int outputSize = RSA_size(self.rsaKey);
    encData = [[NSMutableData alloc] initWithLength:outputSize];
    int padding = oaep ? RSA_PKCS1_OAEP_PADDING : RSA_PKCS1_PADDING;
    NSInteger res =
        RSA_public_encrypt((int32_t)data.length, [data bytes], [encData mutableBytes], self.rsaKey, padding);
    if (res <= 0) {
        return nil;
    }
    [encData setLength:res];

    return encData;
}

- (BOOL)verify:(NSData *)data
      withOffset:(NSInteger)offset
       andLength:(NSInteger)length
    andSignature:(NSString *)signature {
    if (!self.rsaKey || signature.length < 4) {
        return NO;
    }

    const char *dataPtr = [data bytes];
    dataPtr += offset;

    MD5_CTX hash;
    unsigned char md5[16] = {0};
    MD5_Init(&hash);
    MD5_Update(&hash, dataPtr, length);
    MD5_Final(md5, &hash);

    return [self verify:md5 withSignature:signature];
}

- (BOOL)verify:(unsigned char *)md5 withSignature:(NSString *)signature {
    BOOL verified = NO;
    size_t sigLength = signature.length;

    if (!md5 || !self.rsaKey || sigLength < 4) {
        verified = NO;
    } else {
        NSInteger size = ((sigLength + 4) / 4 * 3);

        NSMutableData *raw = [[NSMutableData alloc] initWithLength:size];
        unsigned char *rawPtr = [raw mutableBytes];
        NSData *signatureEncoded = [[NSData alloc] initWithBytes:[signature cStringUsingEncoding:NSUTF8StringEncoding]
                                                          length:sigLength + 1];
        const unsigned char *sigPtr = [signatureEncoded bytes];

        NSInteger len = EVP_DecodeBlock(rawPtr, sigPtr, (int32_t)sigLength);

        if (len > 0 && !(len % 3)) {
            if (sigPtr[sigLength - 1] == '=') {
                --len;
            }
            if (sigPtr[sigLength - 2] == '=') {
                --len;
            }
        }

        if (len > 0) {
            [raw setLength:len];
            rawPtr = [raw mutableBytes];
            int res = RSA_verify(NID_md5, md5, 16, rawPtr, (int32_t)len, self.rsaKey);
            verified = res == 1;
        }
    }
    return verified;
}

- (void)reset {
    self.serialized = nil;
    if (self.rsaKey) {
        RSA_free(self.rsaKey);
        self.rsaKey = nil;
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

- (void)clear {
    [self reset];
}

@end
