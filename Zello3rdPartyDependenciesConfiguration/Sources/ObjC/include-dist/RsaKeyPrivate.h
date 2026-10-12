#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RsaKeyPrivate <NSObject>

- (nullable NSString *)sign:(NSData *)data;
- (nullable NSData *)decrypt:(NSData *)data withOaep:(BOOL)oaep;
- (nullable NSString *)serialize;
- (BOOL)deserialize:(NSString *)s;

@end

NS_ASSUME_NONNULL_END
