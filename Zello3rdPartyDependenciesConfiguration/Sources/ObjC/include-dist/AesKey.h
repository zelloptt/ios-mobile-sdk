#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AesKey <NSObject>
- (nullable NSData *)encrypt:(NSData *)data;
- (nullable NSData *)encrypt:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length;
- (nullable NSData *)decrypt:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length;

- (NSData *)getKeyData;
- (BOOL)isValid;
@end

NS_ASSUME_NONNULL_END
