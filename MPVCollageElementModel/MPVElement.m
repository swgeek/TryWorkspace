//
//  MPVElement.m
//  MPVCollageModelViewHelper
//
//  Created by Manoj Patel on 1/6/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import "MPVElement.h"
#import "MPVCollageModelHelper.h"
#import "MPVCollageElementModel+Convenience.h"
#import "MPVUtilities.h"

@interface MPVElement()

@property MPVCollageElementModel * elementModel;

@property (nonatomic, strong, readwrite) UIColor * borderColor;
@property (nonatomic, readwrite) float borderWidth;
@property (nonatomic, strong, readwrite) UIColor * color;
@property (nonatomic, readwrite) float height;
@property (nonatomic, strong, readwrite) UIImage * image;
@property (nonatomic, readwrite) float imageScale;
@property (nonatomic, readwrite) float imageX;
@property (nonatomic, readwrite) float imageY;
@property (nonatomic, readwrite) float opacity;
@property (nonatomic, strong, readwrite) UIImage * thumbnail;
@property (nonatomic, readwrite) float width;
@property (nonatomic, readwrite) float x;
@property (nonatomic, readwrite) float y;
@property (nonatomic, readwrite) float thumbnailToImageScale;

@property (nonatomic, readwrite) int index;
@end

@implementation MPVElement

- (id) initWithElementModel:(MPVCollageElementModel *) model
{
    self = [super init];
    if (self)
    {
        self.x = model.x;
        self.y = model.y;
        self.width = model.width;
        self.height = model.height;
        self.color = model.color;
        self.borderWidth = model.borderWidth;
        self.borderColor = model.borderColor;
        self.image = [model getSavedImage];
        self.opacity = model.opacity;
        self.index = model.index;
        self.imageX = model.imageX;
        self.imageY = model.imageY;
        self.imageScale = model.imageScale;
        self.elementModel = model;
    }
    return self;
    
}

- (float)minScaleToFitImage:(UIImage *)image
{
    if (! image)
        return 0;
    
    float heightRatio = self.height / image.size.height;
    float widthRatio = self.width / image.size.width;
    return MAX(heightRatio, widthRatio);
}

- (void) removeImage
{
    self.image = nil;
    self.thumbnail = nil;
    [self.elementModel removeImage];
    
}

- (void) updateImagePosition:(CGPoint) position andScale:(float)newScale
{
    self.imageX = position.x;
    self.imageY = position.y;
    self.imageScale = newScale;
    [self.elementModel updatePosition:position andScale:newScale];
}

- (void) setNewImage:(UIImage *)image
{
    if (!image)
        return;
    
    [self removeImage];

//    if (longEdge < MAX(image.size.height, image.size.width))
//    {
//        self.thumbnail = [MPVUtilities createThumbnail:image withLongEdge:longEdge];
//        self.thumbnailToImageScale = self.thumbnail.size.height / image.size.height;
//    }
    
    self.image = image;
    [self centerImage:image];
    
    [self.elementModel setNewImage:image withX:self.imageX Y:self.imageY andScale:self.imageScale];
}

// This fails if using thumbnail. How to fix this?
- (void) centerImage:(UIImage *)image
{
    self.imageScale = [self minScaleToFitImage:image];
    
    float newHeight = image.size.height * self.imageScale;
    float newWidth = image.size.width * self.imageScale;
    
    self.imageY = (newHeight - self.height)/2;
    self.imageX = (newWidth - self.width)/2;
    
    [self.elementModel updatePosition:CGPointMake(self.imageX, self.imageY) andScale:self.imageScale];
}


@end
