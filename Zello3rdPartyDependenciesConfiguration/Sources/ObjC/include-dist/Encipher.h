#import <Foundation/Foundation.h>

@protocol AesKey;

NS_ASSUME_NONNULL_BEGIN

@protocol Encipher <NSObject>

- (void)setKey:(id<AesKey>)key;
- (nullable NSData *)encode:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
