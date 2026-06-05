#import <Foundation/Foundation.h>
#import "ZelloSecureCompat.h"

@protocol RsaKeyPublic;
@protocol RsaKeyPrivate;

NS_ASSUME_NONNULL_BEGIN

@interface RsaKeyPairImpl : NSObject <RsaKeyPair>

- (id)initWithBitSize:(NSInteger)rsaKeyBits;
- (id)initWithPublicKey:(id<RsaKeyPublic>)publicKey privateKey:(id<RsaKeyPrivate>)privateKey;
- (nullable id<RsaKeyPublic>)getKeyPublic;
- (nullable id<RsaKeyPrivate>)getKeyPrivate;

@end

NS_ASSUME_NONNULL_END
