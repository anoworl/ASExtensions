
#import <UIKit/UIKit.h>

@interface UINavigationItem (Spacing)

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem space:(CGFloat)space;
- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem space:(CGFloat)space;

@end