//
//  MPVCollageView.h
//  MPVCollageView
//
//  Created by Manoj Patel on 12/28/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPVCollageViewDelegate <NSObject>

@required

- (void) zoomChangedToScale:(float) newScale andOrigin:(CGPoint) newPosition senderTag:(NSInteger)tag;

@optional

- (void) elementTapped:(UIGestureRecognizer *)recognizer senderTag:(NSInteger)tag;
- (void) elementLongPress:(UIGestureRecognizer *)recognizer senderTag:(NSInteger)tag;

- (void) collageTapped:(UIGestureRecognizer *)recognizer senderTag:(NSInteger)tag;
@end

@interface MPVCollageView : UIView

@property (nonatomic) float globalBorderWidth;
@property (strong, nonatomic) UIColor * globalBorderColor;

- (id)initWithFrame:(CGRect)frame andDelegate:(id<MPVCollageViewDelegate>)delegate;

// use rectangle only for previews, element for actual collage
- (void) addRectangleWithX:(float)x
                         Y:(float)y
                     width:(float) width
                    height:(float)height
                     color:(UIColor *)color
               borderWidth:(float)borderWidth
               borderColor:(UIColor *)borderColor
                   opacity:(float)opacity;

- (void) addElementWithX:(float) x
                       Y:(float)y
                   width:(float) width
                  height:(float)height
                   color:(UIColor *)color
             borderWidth:(float)borderWidth
             borderColor:(UIColor *)borderColor
                   image:(UIImage *)image
                  imageX:(float)imageX
                  imageY:(float)imageY
              imageScale:(float)imageScale
   thumbnailToImageScale:(float)thumbnailScale
                minScale:(float)minScale
                 opacity:(float)opacity
                  andTag:(NSInteger)tag;

- (void) setImage:(UIImage *)image withThumbnailToImageScale:(float)thumbnailScale X:(float)x Y:(float)y scale:(float)scale minScale:(float)minScale forElement:(NSInteger)tag;

- (void) removeImageFromElement:(NSInteger)tag;

@end
