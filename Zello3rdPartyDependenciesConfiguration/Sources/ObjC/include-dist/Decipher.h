#import <Foundation/Foundation.h>

@protocol AesKey;

NS_ASSUME_NONNULL_BEGIN

@protocol Decipher <NSObject>

- (nullable instancetype)initWithKey:(id<AesKey>)key;
- (nullable NSData *)decode:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
