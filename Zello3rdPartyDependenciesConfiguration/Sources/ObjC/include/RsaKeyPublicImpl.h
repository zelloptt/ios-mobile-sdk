#import <Foundation/Foundation.h>
#import <OpenSSL/ossl_typ.h>
#import <ZelloSecure/ZelloSecure.h>

NS_ASSUME_NONNULL_BEGIN

@interface RsaKeyPublicImpl: NSObject <RsaKeyPublic>
- (id)initWithKey:(nullable RSA *)key;
- (nullable NSString *)serialize;

// FIXME: Remove -deserialize: method and replace with initializer
- (BOOL)deserialize:(NSString *)s;
- (BOOL)isValid;
- (nullable NSData *)encrypt:(NSData *)data;

// FIXME: Remove -clear method
// It's only used for resource cleanup when -deserialize: fails
- (void)clear;

- (BOOL)verify:(NSData *)data
    withOffset:(NSInteger)offset
     andLength:(NSInteger)length
  andSignature:(NSString *)signature;
@end

NS_ASSUME_NONNULL_END
