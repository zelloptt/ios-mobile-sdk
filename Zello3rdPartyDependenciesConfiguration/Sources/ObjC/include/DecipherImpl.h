#import <Foundation/Foundation.h>
#import <ZelloSecure/ZelloSecure.h>

@protocol AesKey;

NS_ASSUME_NONNULL_BEGIN

@interface DecipherImpl: NSObject <Decipher>

- (void)setKey:(id<AesKey>)key;
- (nullable NSData *)decode:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
