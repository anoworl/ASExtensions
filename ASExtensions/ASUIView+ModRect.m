
#import "ASUIView+ModRect.h"

@implementation UIView (ModRect)

- (void)moveAt:(CGPoint)point{
    CGRect r = self.frame;
    r.origin = point;
    self.frame = r;
}

- (void)moveXat:(CGFloat)x{
    CGRect r = self.frame;
    r.origin.x = x;
    self.frame = r;
}

- (void)moveYat:(CGFloat)y{
    CGRect r = self.frame;
    r.origin.y = y;
    self.frame = r;
}

- (void)scaleTo:(CGSize)size{
    CGRect r = self.frame;
    r.size = size;
    self.frame = r;
}

@end
