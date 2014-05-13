//
//  CollageElementModel+Convenience.m
//  TryElementModel
//
//  Created by Manoj Patel on 12/21/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "CollageElementModel+Convenience.h"
#import "MPVUtilities.h"

@implementation CollageElementModel (Convenience)

NSString * elementClassName = @"CollageElementModel";

- (UIColor *) color
{
    return [MPVUtilities ColorFromData:self.colorData];
}

- (void) setColor:(UIColor *)color
{
    self.colorData = [MPVUtilities DataFromColor:color];
}

- (UIColor *) borderColor
{
    return [MPVUtilities ColorFromData:self.borderColorData];
}

- (void) setBorderColor:(UIColor *)borderColor
{
    self.borderColorData = [MPVUtilities DataFromColor:borderColor];
}

- (UIImage *) image
{
    if (!self.imageData)
        return nil;

    UIImage * newImage = [UIImage imageWithData:self.imageData];
    return newImage;
}

- (void) setImage:(UIImage *)image
{
    if (!image)
        return;
    
    // assume external files deleted once correspending field deleted,
    // but do a sanity check sometime...
    
    self.imageData = UIImagePNGRepresentation(image);
    
    [self centerImage:image];
}

- (void) centerImage:(UIImage *)image
{
    self.imageScale = [self minScaleToFitImage:image];
    
    float newHeight = image.size.height * self.imageScale;
    float newWidth = image.size.width * self.imageScale;
    
    self.imageY = (newHeight - self.height)/2;
    self.imageX = (newWidth - self.width)/2;
}

- (float)minScaleToFitImage:(UIImage *)image
{
    float heightRatio = self.height / image.size.height;
    float widthRatio = self.width / image.size.width;
    return MAX(heightRatio, widthRatio);
}
@end
