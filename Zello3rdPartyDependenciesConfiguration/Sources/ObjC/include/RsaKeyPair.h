#import <Foundation/Foundation.h>

@protocol RsaKeyPublic;
@protocol RsaKeyPrivate;

NS_ASSUME_NONNULL_BEGIN

@protocol RsaKeyPair <NSObject>

- (nullable id<RsaKeyPublic>)getKeyPublic;
- (nullable id<RsaKeyPrivate>)getKeyPrivate;

@end

NS_ASSUME_NONNULL_END
