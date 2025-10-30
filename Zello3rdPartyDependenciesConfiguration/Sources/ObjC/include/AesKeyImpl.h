#import <Foundation/Foundation.h>
#import <ZelloSecure/ZelloSecure.h>

NS_ASSUME_NONNULL_BEGIN

@interface AesKeyImpl: NSObject <AesKey>
- (id)initWithDataKey:(NSData *)dataKeyIn;
- (nullable NSData *)encrypt:(NSData *)data;
- (nullable NSData *)encrypt:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length;
- (nullable NSData *)decrypt:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length;

- (NSData *)getKeyData;
- (BOOL)isValid;
@end

NS_ASSUME_NONNULL_END
