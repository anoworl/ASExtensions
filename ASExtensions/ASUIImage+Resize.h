
#import <UIKit/UIKit.h>

@interface UIImage (Resize)

// 中心を正方形にクロップ
- (UIImage *)croppedImage;

// 指定位置をクロップ
- (UIImage *)croppedImage:(CGRect)bounds;

// 指定サイズでリサイズ（Exif:Orientationは考慮される）
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

// アスペクト比を保ったまま自動リサイズ (Exif:Orientationは考慮される)
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

// Orientationを考慮したリサイズ
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

// 画像を正しい向きにするためのTransformを取得
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

// 画像を標準の向きに修正する
- (UIImage *)normalizeImageOrientation;

// GroupスタイルのCellの角削除
- (UIImage *)roundedCornersForGroupedCell:(UIRectCorner)corners;
- (UIImage *)roundedCornersForGroupedCell:(UIRectCorner)corners withSize:(CGFloat)size;

@end
