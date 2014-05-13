//
//  MPVImageScrollView.m
//  TryScrollViewContainer
//
//  Created by Manoj Patel on 12/12/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVImageScrollView.h"

@interface MPVImageScrollView()

@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UITapGestureRecognizer * tapRecognizer;
@property (strong, nonatomic) UILongPressGestureRecognizer * longPressRecognizer;
@end

@implementation MPVImageScrollView

- (void) setImage: (UIImage *)image WithPosition:(CGPoint)point scale:(float)scale minScale:(float)minScale andMaxScale:(float)maxScale;
{
    if (! image)
        return;
    
    if (self.imageView)
        [self removeImage];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:self.imageView];
    [self addSubview:self.scrollView];
    
    self.scrollView.contentSize = image.size;
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = maxScale;
    self.scrollView.zoomScale = scale;
    self.scrollView.contentOffset = point;

}

- (void) centerAndFitImage:(UIImage *)image
{
    float heightRatio = self.bounds.size.height / image.size.height;
    float widthRatio = self.bounds.size.width / image.size.width;
    float scale = MIN(heightRatio, widthRatio);

    float xOffset = (self.bounds.size.width - (image.size.width * scale))/2;
    float yOffset = (self.bounds.size.height - (image.size.height * scale))/2;
    
    float maxScale = 1.0/scale;
    
    [self setImage:image WithPosition:CGPointMake(xOffset, yOffset) scale:scale minScale:scale andMaxScale:maxScale];
    
}


- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self updatePositionAndScale];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self updatePositionAndScale];
}

- (void) updatePositionAndScale
{
    CGPoint newOffset = self.scrollView.contentOffset;
    float newScale = self.scrollView.zoomScale;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoomChangedToScale:andOrigin:sender:)])
    {
        [self.delegate zoomChangedToScale:newScale andOrigin:newOffset sender:self];
    }
}

- (void) removeImage
{
    if (self.imageView)
    {
        // removing instead of simply replacing image as get zoom problems otherwise
        [self.imageView removeFromSuperview];
        self.imageView = nil;
    }
    
    if (self.scrollView)
    {
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
        
    }
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (BOOL) hasImage
{
    return (self.imageView != nil);
}

- (void) tapEnable:(BOOL)enableFlag
{
    if (enableFlag)
        [self addGestureRecognizer:self.tapRecognizer];
    else
    {
        if ([self.gestureRecognizers containsObject:self.tapRecognizer])
            [self removeGestureRecognizer:self.tapRecognizer];
    }
}


- (void) onTapped:(UIGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageScrollViewTapped:fromView:)])
        [self.delegate imageScrollViewTapped:recognizer fromView:self];
}

- (void) longPressEnable:(BOOL)enableFlag
{
    if (enableFlag)
        [self addGestureRecognizer:self.longPressRecognizer];
    else
    {
        if ([self.gestureRecognizers containsObject:self.longPressRecognizer])
            [self removeGestureRecognizer:self.longPressRecognizer];
    }
}

- (void) onLongPress:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageScrollViewLongPress:fromView:)])
        [self.delegate imageScrollViewLongPress:recognizer fromView:self];
}

- (UITapGestureRecognizer *) tapRecognizer
{
    if (!_tapRecognizer)
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    return _tapRecognizer;
}

- (UILongPressGestureRecognizer *) longPressRecognizer
{
    if (!_longPressRecognizer)
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    return _longPressRecognizer;
}

@end
