//
//  MPVElement.h
//  MPVCollageModelViewHelper
//
//  Created by Manoj Patel on 1/6/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//
// Wrapper for element model.
// Using this as core data is a pain to debug etc
// Nothing outside this project should need the actual model, use this always...
// maybe get rid of the category (convenience class) and move everything here...
// OR just get rid of this and use model directly. Will decide later.
// useful to use this at least for the image, as can save image in background that way
//
// Could even just present an interface (protocol) to user, that way can switch between this and the model if needed.

#import <Foundation/Foundation.h>

@class MPVCollageElementModel;

@interface MPVElement : NSObject

// readonly
@property (nonatomic, strong, readonly) UIColor * borderColor;
@property (nonatomic, readonly) float borderWidth;
@property (nonatomic, strong, readonly) UIColor * color;
@property (nonatomic, readonly) float height;
@property (nonatomic, strong, readonly) UIImage * image;
@property (nonatomic, readonly) float imageScale;
@property (nonatomic, readonly) float imageX;
@property (nonatomic, readonly) float imageY;
@property (nonatomic, readonly) float opacity;
@property (nonatomic, strong, readonly) UIImage * thumbnail;
@property (nonatomic, readonly) float width;
@property (nonatomic, readonly) float x;
@property (nonatomic, readonly) float y;
@property (nonatomic, readonly) float thumbnailToImageScale;

@property (nonatomic, readonly) int index;

// maybe do not add image from here as it means reading from file, do that
// in a background thread? Do that later, for now get it working...
- (id) initWithElementModel:(MPVCollageElementModel *) model;

// so can center image when add it
- (float)minScaleToFitImage:(UIImage *)image;

- (void) removeImage;

- (void) updateImagePosition:(CGPoint) position andScale:(float)newScale;

// skip thumbnail for now, not implemented fully yet. Later version.
//- (void) setNewImage:(UIImage *)image withThumbnailLongEdge:(float)longEdge;

- (void) setNewImage:(UIImage *)image;

@end
