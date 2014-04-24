
#import "ASNavigationItem+Spacing.h"

@implementation UINavigationItem (Spacing)

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem{
    [self addLeftBarButtonItem:leftBarButtonItem space:-10];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    [self addRightBarButtonItem:rightBarButtonItem space:-10];
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem space:(CGFloat)space{
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = space;
        [self setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
        if(!leftBarButtonItem){
            self.leftBarButtonItem = nil;
        }
        
    } else {
        [self setLeftBarButtonItem:leftBarButtonItem];
    }
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem space:(CGFloat)space{
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = space;
        [self setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
        if(!rightBarButtonItem){
            self.leftBarButtonItem = nil;
        }
        
    } else {
        [self setRightBarButtonItem:rightBarButtonItem];
    }
}

@end