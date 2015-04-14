//
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 10.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//


#import "UIImage+Crop.h"

@implementation UIImage(CropCategory)
- (UIImage *)crop:(CGRect)rect {

    rect = CGRectMake(rect.origin.x * self.scale,
                      rect.origin.y * self.scale,
                      rect.size.width * self.scale,
                      rect.size.height * self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}
@end
