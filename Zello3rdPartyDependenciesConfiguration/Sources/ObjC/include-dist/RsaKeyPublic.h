#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RsaKeyPublic <NSObject>
- (nullable NSString *)serialize;

// FIXME: Remove -deserialize: method and replace with initializer
- (BOOL)deserialize:(NSString *)s;
- (BOOL)isValid;
- (nullable NSData *)encrypt:(NSData *)data withOaep:(BOOL)oaep;

// FIXME: Remove -clear method
// It's only used for resource cleanup when -deserialize: fails
- (void)clear;

- (BOOL)verify:(NSData *)data
      withOffset:(NSInteger)offset
       andLength:(NSInteger)length
    andSignature:(NSString *)signature;
@end

NS_ASSUME_NONNULL_END
