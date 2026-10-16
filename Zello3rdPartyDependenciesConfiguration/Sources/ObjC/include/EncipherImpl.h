#import <Foundation/Foundation.h>
#import "ZelloSecureCompat.h"

@protocol AesKey;

NS_ASSUME_NONNULL_BEGIN

@interface EncipherImpl : NSObject <Encipher>

- (void)setKey:(id<AesKey>)key;
- (nullable NSData *)encode:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
