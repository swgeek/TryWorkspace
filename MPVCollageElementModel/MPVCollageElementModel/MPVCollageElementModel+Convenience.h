//
//  CollageElementModel+Convenience.h
//  MPVCollageElementModel
//
//  Created by Manoj Patel on 12/21/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVCollageElementModel.h"

@interface MPVCollageElementModel (Convenience)

@property (weak, nonatomic) UIColor * color;
@property (weak, nonatomic) UIColor * borderColor;

extern NSString * elementClassName; //@"MPVCollageElementModel"

- (UIImage *) getSavedImage;
- (UIImage *) getSavedThumbnail;

// skip thumbnail for now, fix in later versions. Mostly have to figure out how to
// handle scale value
//- (void) setNewImage:(UIImage *)image withThumbnailLongEdge:(float)thumbnailLongEdge;
- (void) setNewImage:(UIImage *)image withX:(float)x Y:(float)y andScale:(float)scale;
- (void) removeImage;
- (void) updatePosition:(CGPoint)newPosition andScale:(float)newScale;

@end
