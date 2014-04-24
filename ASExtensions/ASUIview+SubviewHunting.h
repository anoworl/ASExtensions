
#import <UIKit/UIKit.h>

@interface UIView (SubviewHunting)

- (UIView *)huntedSubviewWithClassName:(NSString*)className;
- (void)debugSubviews;

@end
