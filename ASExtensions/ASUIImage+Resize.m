
#import "ASUIImage+Resize.h"

@implementation UIImage (Resize)

// 中心を正方形にクロップ
- (UIImage *)croppedImage{
	CGFloat w = self.size.width;
	CGFloat h = self.size.height;
	CGFloat size = (w < h) ? w : h;
	
	CGFloat sx = self.size.width/2 - size/2;
	CGFloat sy = self.size.height/2 - size/2;
	CGRect rect = CGRectMake(sx, sy, size, size);
	
	CGImageRef cgImage = CGImageCreateWithImageInRect([self CGImage], rect);
	UIImage *img = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
    
	return img;
}

// 指定位置をクロップ
- (UIImage *)croppedImage:(CGRect)bounds{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

// 指定サイズでリサイズ（Exif:Orientationは考慮される）
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality{
    BOOL drawTransposed;
    
    switch(self.imageOrientation){
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// アスペクト比を保ったまま自動リサイズ (Exif:Orientationは考慮される)
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality{
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch(contentMode){
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode"];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    return [self resizedImage:newSize interpolationQuality:quality];
}

// Orientationを考慮したリサイズ
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality{
	
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;

    // Build a context that's the same dimensions as the new size
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	if((bitmapInfo == kCGImageAlphaLast) || (bitmapInfo == kCGImageAlphaNone))
		bitmapInfo = kCGImageAlphaNoneSkipLast;
    
//    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef); // PNG8が失敗する
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                colorSpace,
                                                bitmapInfo);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
	
    return newImage;
}

// 画像を正しい向きにするためのTransformを取得
- (CGAffineTransform)transformForOrientation:(CGSize)newSize{
    CGAffineTransform transform = CGAffineTransformIdentity;
	
    switch(self.imageOrientation){
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        case UIImageOrientationUp:;
        case UIImageOrientationUpMirrored:;
    }
    
    switch(self.imageOrientation){
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationUp:;
        case UIImageOrientationDown:;
        case UIImageOrientationLeft:;
        case UIImageOrientationRight:;
    }
    
    return transform;
}

// 画像を標準の向きに修正する
- (UIImage *)normalizeImageOrientation{

    CGImageRef imageRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
	
	// Orientation = 1
    CGSize size = CGSizeMake(width, height);
    CGAffineTransform affineTransform;
	affineTransform = CGAffineTransformMakeScale(1, -1);			
	affineTransform = CGAffineTransformTranslate(affineTransform, 0, -height);			
	
    UIGraphicsBeginImageContext(size);	
    CGContextRef context = UIGraphicsGetCurrentContext();	
    CGContextConcatCTM(context, affineTransform);	
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();	
    UIGraphicsEndImageContext();
	
    return newImage;	
}

// GroupスタイルのCellの角削除
- (UIImage *)roundedCornersForGroupedCell:(UIRectCorner)corners{
    return [self roundedCornersForGroupedCell:corners withSize:32.0];
}

- (UIImage *)roundedCornersForGroupedCell:(UIRectCorner)corners withSize:(CGFloat)size{
    
    CGRect rect = CGRectMake(0.f, 0.f, self.size.width, self.size.height);
    
    CGPathRef clippingPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(size, size)].CGPath;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, clippingPath);
    CGContextClip(context);
    [self drawInRect:rect];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

@end