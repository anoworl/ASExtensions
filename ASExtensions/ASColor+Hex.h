
// Originally from here
// http://arstechnica.com/apple/2009/02/iphone-development-accessing-uicolor-components/

#import <UIKit/UIKit.h>

@interface UIColor (Hex) 

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

- (NSString *)stringFromColor;
- (NSString *)hexStringFromColor;

@end
