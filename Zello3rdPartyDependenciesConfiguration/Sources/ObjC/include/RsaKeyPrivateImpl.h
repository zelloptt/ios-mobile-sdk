#import <Foundation/Foundation.h>
#import <OpenSSL/ossl_typ.h>
#import <ZelloSecure/ZelloSecure.h>

NS_ASSUME_NONNULL_BEGIN

@interface RsaKeyPrivateImpl: NSObject <RsaKeyPrivate>

- (instancetype)init;
- (instancetype)initWithKey:(RSA *)key;
- (nullable NSString *)sign:(NSData *)data;
- (nullable NSData *)decrypt:(NSData *)data;
- (nullable NSString *)serialize;
- (BOOL)deserialize:(NSString *)s;

@end

NS_ASSUME_NONNULL_END
