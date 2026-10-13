@import OpenSSL;

#import "RsaKeyPairImpl.h"
#import "RsaKeyPrivateImpl.h"
#import "RsaKeyPublicImpl.h"

@interface RsaKeyPairImpl () {
    RSA *rsaKey;
}
@property (atomic, strong) id<RsaKeyPublic> keyPublic;
@property (atomic, strong) id<RsaKeyPrivate> keyPrivate;
@end

@implementation RsaKeyPairImpl
static int RSA_KEY_FLAGS = 0;

- (id)initWithBitSize:(NSInteger)rsaKeyBits {
    self = [super init];

    if (self) {
        rsaKey = nil;
        [self generateKeyPair:rsaKeyBits];

        self.keyPublic = [[RsaKeyPublicImpl alloc] initWithKey:rsaKey];
        self.keyPrivate = [[RsaKeyPrivateImpl alloc] initWithKey:rsaKey];
    }
    return self;
}

- (id)initWithPublicKey:(id<RsaKeyPublic>)publicKey privateKey:(id<RsaKeyPrivate>)privateKey {
    self = [super init];

    if (self) {
        self.keyPublic = publicKey;
        self.keyPrivate = privateKey;
    }
    return self;
}

- (id)init {
    return [self initWithBitSize:1024];
}

- (id<RsaKeyPrivate>)getKeyPrivate {
    return self.keyPrivate;
}

- (id<RsaKeyPublic>)getKeyPublic {
    return self.keyPublic;
}

- (void)generateKeyPair:(NSInteger)nBits {
    if (rsaKey) {
        [self reset];
    }

    // We're assuming the PRNG has already been seeded successfully. The library is supposed to do
    // that on its own, but we could check for success.
    BIGNUM *e = BN_new();
    BN_set_word(e, RSA_F4);
    rsaKey = RSA_new();
    if (rsaKey) {
        int status = RSA_generate_key_ex(rsaKey, (int)nBits, e, NULL);
        if (status) {
            RSA_set_flags(rsaKey, RSA_KEY_FLAGS);
        }
    }
}

- (void)reset {
    if (rsaKey) {
        RSA_free(rsaKey);
        rsaKey = nil;
    }
}

- (void)dealloc {
    [self reset];
}

@end
