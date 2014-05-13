//
//  MPVCollageView.m
//  MPVCollageView
//
//  Created by Manoj Patel on 12/28/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVCollageView.h"
#import "MPVImageScrollView.h"

@interface MPVCollageView() <MPVImageScrollDelegate>

@property (weak, nonatomic) id<MPVCollageViewDelegate> delegate;

// key is integer tag, value is MPVImageScrollView
@property (strong, nonatomic) NSMutableDictionary * imageScrollList;

// used when tapped or long press, so know which element requested interaction
@property (strong, nonatomic) MPVImageScrollView * currentElement;

@end

@implementation MPVCollageView

- (NSMutableDictionary *) imageScrollList
{
    if (!_imageScrollList)
        _imageScrollList = [[NSMutableDictionary alloc] init];
    return _imageScrollList;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id<MPVCollageViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = delegate;
    }
    return self;
}

- (void) addRectangleWithX:(float)x
                         Y:(float)y
                     width:(float) width
                    height:(float)height
                     color:(UIColor *)color
               borderWidth:(float)borderWidth
               borderColor:(UIColor *)borderColor
                   opacity:(float)opacity
{
    CGRect rect = CGRectMake(x, y, width, height);
    // can I do this without a view? Just color a rect? Probably, check how...
    UIView * newView = [[UIView alloc] initWithFrame:rect];
    newView.backgroundColor = color;
    
    if ((borderWidth <0) && (self.globalBorderWidth >= 0))
    {
        newView.layer.borderWidth = self.globalBorderWidth;
        newView.layer.borderColor = [self.globalBorderColor CGColor];
    }
    else
    {
        newView.layer.borderColor = [borderColor CGColor];
        newView.layer.borderWidth = borderWidth;
    }
    
    if (opacity < 1) // should I add a delta for rounding error?
        newView.opaque = YES;
    else
        newView.opaque = NO;
    
    newView.alpha = opacity;
    
    [self addSubview:newView];
}

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
                  andTag:(NSInteger)tag
{
    CGRect rect = CGRectMake(x, y, width, height);
    MPVImageScrollView * newView = [[MPVImageScrollView alloc] initWithFrame:rect];
    newView.delegate = self;
    newView.backgroundColor = color;
    [newView setImage:image WithPosition:CGPointMake(imageX, imageY) scale:imageScale minScale:minScale andMaxScale:2];
    
    // Note, lose scrollview bars within border. Can we fix that?
    // maybe resize the scrollview to fit within area?
    if ((borderWidth <0) && (self.globalBorderWidth >= 0))
    {
        newView.layer.borderWidth = self.globalBorderWidth;
        newView.layer.borderColor = [self.globalBorderColor CGColor];
    }
    else
    {
        newView.layer.borderColor = [borderColor CGColor];
        newView.layer.borderWidth = borderWidth;
    }
    
    if (opacity < 1) // should I add a delta for rounding error?
        newView.opaque = YES;
    else
        newView.opaque = NO;
    
    newView.alpha = opacity;
    
    newView.tag = tag;
    [self.imageScrollList setObject:newView forKey:[NSNumber numberWithInteger:tag]];
    [self addSubview:newView];
    
    if (newView.hasImage)
    {
        [newView tapEnable:NO];
        [newView longPressEnable:YES];
    }
    else
    {
        [newView tapEnable:YES];
        [newView longPressEnable:NO];
    }
}

- (void) setImage:(UIImage *)image withThumbnailToImageScale:(float)thumbnailScale X:(float)x Y:(float)y scale:(float)scale minScale:(float)minScale forElement:(NSInteger)tag
{
    if (! self.imageScrollList)
        return;
    
    MPVImageScrollView * imageScrollView = [self.imageScrollList objectForKey:[NSNumber numberWithInteger:tag]];
    
    [imageScrollView setImage:image WithPosition:CGPointMake(x, y) scale:scale minScale:minScale andMaxScale:2];
    
    [imageScrollView tapEnable:NO];
    [imageScrollView longPressEnable:YES];
}

- (void) removeImageFromElement:(NSInteger)tag
{
    if (! self.imageScrollList)
        return;
    
    MPVImageScrollView * imageScrollView = [self.imageScrollList objectForKey:[NSNumber numberWithInteger:tag]];
    
    [imageScrollView removeImage];
    [imageScrollView tapEnable:YES];
    [imageScrollView longPressEnable:NO];
}

- (void) zoomChangedToScale:(float)newScale andOrigin:(CGPoint)newPosition sender:(MPVImageScrollView *)sender
{
    [self.delegate zoomChangedToScale:newScale andOrigin:newPosition senderTag:sender.tag];
}

- (void) imageScrollViewTapped:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
{
    self.currentElement = senderView;
    
    // check if responds to selector first!
    [self.delegate elementTapped:recognizer senderTag:senderView.tag];
}

- (void) imageScrollViewLongPress:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
{
    self.currentElement = senderView;
    
    // check if responds to selector first!
    [self.delegate elementLongPress:recognizer senderTag:senderView.tag];
}
@end
