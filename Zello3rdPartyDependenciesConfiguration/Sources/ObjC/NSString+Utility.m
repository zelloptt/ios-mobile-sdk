#import "NSString+Utility.h"

@implementation NSString (Utility)
- (NSInteger)indexOf:(NSString *)substring {
  if (substring) {
    NSRange range = [self rangeOfString:substring];
    return range.location == NSNotFound ? -1 : range.location;
  }
  return -1;
}
@end

