//
//  MPVImageScrollView.h
//  TryScrollViewContainer
//
//  Created by Manoj Patel on 12/12/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

// Wrapper for scrollview that takes an image and handles tap and longpress gesture recognizers
// user may optionally set delegate to handle the tap and longpress gestures.
#import <UIKit/UIKit.h>


@class MPVImageScrollView;

@protocol MPVImageScrollDelegate <NSObject>

@required

- (void) zoomChangedToScale:(float) newScale andOrigin:(CGPoint) newPosition sender:(MPVImageScrollView *)sender;

@optional

- (void) imageScrollViewTapped:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView;

- (void) imageScrollViewLongPress:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView;

@end

@interface MPVImageScrollView : UIView <UIScrollViewDelegate>

// Weak in case of circular references
@property (weak, nonatomic) id<MPVImageScrollDelegate> delegate;

- (void) setImage: (UIImage *)image WithPosition:(CGPoint)point scale:(float)scale minScale:(float)minScale andMaxScale:(float)maxScale;

- (void) centerAndFitImage:(UIImage *)image;

- (void) removeImage;

- (BOOL) hasImage;

// if set to yes, owner should implement "imageScrollViewTapped:"
- (void) tapEnable:(BOOL)enableFlag;

// if set to yes, owner should implement "imageScrollViewLongPress:"
- (void) longPressEnable:(BOOL) enableFlag;

@end
