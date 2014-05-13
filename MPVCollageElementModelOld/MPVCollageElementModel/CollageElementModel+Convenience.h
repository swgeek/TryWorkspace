//
//  CollageElementModel+Convenience.h
//  TryElementModel
//
//  Created by Manoj Patel on 12/21/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//


//*******TODOTODOTODOTODO
// maybe consolidate model into one entity
// make sure image data is external data
// maybe same for thumbnail data

#import "CollageElementModel.h"

@interface CollageElementModel (Convenience)

@property (weak, nonatomic) UIColor * color;
@property (weak, nonatomic) UIColor * borderColor;
@property (weak, nonatomic) UIImage * image;

extern NSString * elementClassName; //@"CollageElementModel"
extern NSString * imageDataClassName; //@"ImageData"

// useful for figuring out minimum scale on scrollview
// note that this is fit and fill, keeping aspect ratio, i.e. some will go past the edges
- (float) minScaleToFitImage:(UIImage *)image;
@end
