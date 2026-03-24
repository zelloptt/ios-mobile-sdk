#import <Foundation/Foundation.h>
#import <OpenSSL/ossl_typ.h>
#import <ZelloSecure/ZelloSecure.h>

NS_ASSUME_NONNULL_BEGIN

@interface RsaKeyPrivateImpl : NSObject <RsaKeyPrivate>

- (instancetype)init;
- (instancetype)initWithKey:(RSA *)key;
- (nullable NSString *)sign:(NSData *)data;
/// @param oaep If YES, use RSA_PKCS1_OAEP_PADDING option. Otherwise use RSA_PKCS1_PADDING. With a fallback attempt
/// using the opposite padding if needed.
- (nullable NSData *)decrypt:(NSData *)data withOaep:(BOOL)oaep;
- (nullable NSString *)serialize;
- (BOOL)deserialize:(NSString *)s;

@end

NS_ASSUME_NONNULL_END
