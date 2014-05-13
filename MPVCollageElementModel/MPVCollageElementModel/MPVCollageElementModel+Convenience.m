//
//  CollageElementModel+Convenience.m
//  MPVCollageElementModel
//
//  Created by Manoj Patel on 12/21/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVCollageElementModel+Convenience.h"
#import "MPVUtilities.h"

@implementation MPVCollageElementModel (Convenience)

NSString * elementClassName = @"MPVCollageElementModel";

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

// These are methods instead of a property to make it more explicit that
// a lot of work is being done behind the scenes.
// maybe even get rid of the get method completely, let user retrieve from file?
- (UIImage *) getSavedImage
{
    if (!self.imageFilename)
        return nil;

    UIImage * image = [MPVUtilities getImage:self.imageFilename];
    return image;
}

- (UIImage *) getSavedThumbnail
{
    if (!self.thumbnailFilename)
    return nil;

    UIImage * image = [MPVUtilities getImage:self.thumbnailFilename];
    return image;
}

- (void) removeImage
{
    
    if (self.thumbnailFilename)
    {
        [MPVUtilities removeFile:self.thumbnailFilename];
        self.thumbnailFilename = nil;
    }
    
    if (self.imageFilename)
    {
        [MPVUtilities removeFile:self.imageFilename];
        self.imageFilename = nil;
    }
}

- (void) setNewImage:(UIImage *)image withX:(float)x Y:(float)y andScale:(float)scale
{
    if (!image)
        return;
    
    [self removeImage];
    
    NSString * filename = [MPVUtilities saveImage:image];
    self.imageFilename = filename;
    self.imageX = x;
    self.imageY = y;
    self.imageScale = scale;
}

// not using thumbnail right now, may later.
- (void)setNewImage:(UIImage *)image withThumbnailLongEdge:(float)thumbnailLongEdge
{

    if (!image)
        return;

    [self setNewImage:image withX:0 Y:0 andScale:1];
    
    if (thumbnailLongEdge < MAX(image.size.height, image.size.width))
    {
        UIImage * thumbnailImage = [MPVUtilities createThumbnail:image withLongEdge:thumbnailLongEdge];
        self.thumbnailScale = thumbnailImage.size.height / image.size.height;
        NSString * thumbnailFilename = [MPVUtilities saveImage:thumbnailImage];
        self.thumbnailFilename = thumbnailFilename;
    }
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

- (void) updatePosition:(CGPoint)newPosition andScale:(float)newScale
{
    self.imageX = newPosition.x;
    self.imageY = newPosition.y;
    self.imageScale = newScale;
}

@end
