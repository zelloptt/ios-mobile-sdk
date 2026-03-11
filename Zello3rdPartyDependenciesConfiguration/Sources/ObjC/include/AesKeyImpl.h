#import <Foundation/Foundation.h>
#import <ZelloSecure/ZelloSecure.h>

NS_ASSUME_NONNULL_BEGIN

@interface AesKeyImpl: NSObject <AesKey>
/// Creates an AES key object from key data
///
/// @return the new key, or nil if the key data is invalid
- (nullable instancetype)initWithDataKey:(NSData *)dataKeyIn;
- (nullable NSData *)encrypt:(NSData *)data;
- (nullable NSData *)encrypt:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length;
- (nullable NSData *)decrypt:(NSData *)data withOffset:(NSInteger)offset andLength:(NSInteger)length;

- (NSData *)getKeyData;
- (BOOL)isValid;
@end

NS_ASSUME_NONNULL_END
