//
//  MPVViewController.m
//  TryElementModel
//
//  Created by Manoj Patel on 12/19/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVViewController.h"
#import "MPVImageScrollView.h"
#import "MPVUtilities.h"
#import "MPVCollageModelHelper.h"
#import "MPVCollage.h"
#import "MPVElement.h"


@interface MPVViewController () <MPVImageScrollDelegate>
@property (strong, nonatomic) MPVCollageModelHelper * modelHelper;
@property (strong, nonatomic) MPVCollage * collage;
@end

@implementation MPVViewController

NSString * dataStoreFilename = @"trythis31";
NSString * imagefile = @"concept.jpg";
NSString * imagefile2 = @"landing.jpg";

- (void)viewDidLoad
{
    [super viewDidLoad];

    // this could be done at the app delegate level, but for now...
    NSURL * url = [MPVUtilities GetDocumentFileUrl:dataStoreFilename];
    self.modelHelper = [[MPVCollageModelHelper alloc] initWithDocumentUrl:url andCompletionHandler:^(MPVCollage * collage) {
        [self drawElements:collage];
    }];
}


- (void) drawElements: (MPVCollage *)collage
{
    self.collage = collage;
    
    if (! collage)
        self.collage = [self.modelHelper initializeExampleCollage];
    
    if (! self.collage)
        return;
    
    CGRect rect = CGRectMake(0, 0, self.collage.width, self.collage.height);
    UIView * containerView = [[UIView alloc] initWithFrame:rect];
    containerView.backgroundColor = self.collage.backgroundColor;
    
    for (int i=0; i<self.collage.elementCount; i++)
    {
        // draw element i
        MPVImageScrollView * newView = [self imageScrollFromElementModel:[self.collage elementAtIndex:i]];
        newView.tag = i;
        [containerView addSubview:newView];
        [newView tapEnable:YES];
        [newView longPressEnable:YES];
    }
    [MPVUtilities setScaleAndCenterTransforms:containerView toRect:self.view.bounds withMargin:20];
    [self.view addSubview:containerView];
}

- (void)imageScrollViewTapped:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
{
    MPVElement * element = [self.collage elementAtIndex:senderView.tag];
    
    if ([senderView hasImage])
    {
        [senderView removeImage];
        [element removeImage];
    }
    else
    {
        [self setImageWithFilename:imagefile forElement:element andView:senderView];
    }
}

- (void) setImageWithFilename:(NSString  *)filename forElement:(MPVElement *)element andView:(MPVImageScrollView *)view
{
    UIImage * image = [UIImage imageNamed:filename];
    [element setNewImage:image];
    [view setImage:image WithPosition:CGPointMake(element.imageX, element.imageY) scale:element.imageScale minScale:[element minScaleToFitImage:image] andMaxScale:2];
}

- (void) imageScrollViewLongPress:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
{
    MPVElement * element = [self.collage elementAtIndex:senderView.tag];
    
    if ([senderView hasImage])
    {
        [senderView removeImage];
    }
    else
    {
        [self setImageWithFilename:imagefile2 forElement:element andView:senderView];
    }
}

- (MPVImageScrollView *) imageScrollFromElementModel:(MPVElement *) model
{
    CGRect rect = CGRectMake(model.x, model.y, model.width, model.height);
    MPVImageScrollView * newView = [[MPVImageScrollView alloc] initWithFrame:rect];
    newView.delegate = self;
    newView.backgroundColor = model.color;
    UIImage * image = model.image;
    [newView setImage:image WithPosition:CGPointMake(model.imageX, model.imageY) scale:model.imageScale minScale:[model minScaleToFitImage:image] andMaxScale:2];
    
    // Note, lose scrollview bars within border. Can we fix that?
    // maybe resize the scrollview to fit within area?
    newView.layer.borderColor = [model.borderColor CGColor];
    newView.layer.borderWidth = model.borderWidth;
    
    if (model.opacity < 1) // should I add a delta for rounding error?
        newView.opaque = YES;
    else
        newView.opaque = NO;
    
    newView.alpha = model.opacity;
    
    return newView;
}

- (void) zoomChangedToScale:(float)newScale andOrigin:(CGPoint)newPosition sender:(MPVImageScrollView *)sender
{
    [[self.collage elementAtIndex:sender.tag] updateImagePosition:newPosition andScale:newScale];
}

@end
