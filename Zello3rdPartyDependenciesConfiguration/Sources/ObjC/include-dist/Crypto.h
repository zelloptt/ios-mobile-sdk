#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Abstract class
@interface Crypto : NSObject
+ (Crypto *)instance;
- (NSData *)decodeBase64:(NSString *)in;
- (nullable NSData *)generateAesKeyData;
- (NSData *)md5:(NSData *)bytes;
- (NSData *)md5:(NSData *)bytes length:(NSUInteger)length;
- (NSInteger)rand:(NSInteger)max;
- (NSString *)encodeBase64:(NSData *)in withOffset:(NSInteger)offset andLength:(NSInteger)length;
- (NSString *)encodeBase64:(NSData *)in;
- (NSString *)generateUuid;
/**
 * Returns a four character string
 */
- (NSString *)shortId;
@end

NS_ASSUME_NONNULL_END
