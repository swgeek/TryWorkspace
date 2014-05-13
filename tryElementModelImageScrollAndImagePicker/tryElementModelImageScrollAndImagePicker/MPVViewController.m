//
//  MPVViewController.m
//  tryElementModelImageScrollAndImagePicker
//
//  Created by Manoj Patel on 12/27/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVViewController.h"
#import "MPVImageScrollView.h"
#import "MPVCollageElementModelHelper.h"
#import "MPVUtilities.h"
#import "CollageElementModel.h"
#import "CollageElementModel+Convenience.h"
#import "MPVLongPressMenu.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface MPVViewController () <MPVElementDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) MPVCollageElementModelHelper * modelHelper;

// so we know what scrollview triggered the "pick image"
@property (weak, nonatomic) MPVImageScrollView * currentImageScrollView;

@end

@implementation MPVViewController

NSString * dataStoreFilename = @"trythis";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // this could be done at the app delegate level, but for now...
    NSURL * url = [MPVUtilities GetDocumentFileUrl:dataStoreFilename];
    self.modelHelper = [[MPVCollageElementModelHelper alloc] initWithDocumentUrl:url andCompletionHandler:^(void){
        dispatch_async(dispatch_get_main_queue(), ^{[self drawElements];});}];
}

- (void) createInitialModel
{
    [self.modelHelper addElementModelwithX:40 Y:40 width:100 height:100 color:[UIColor blueColor]  borderWidth:-1 borderColor:nil image:nil andOpacity:1];
    
    [self.modelHelper addElementModelwithX:40 Y:160 width:200 height:300 color:[UIColor greenColor] borderWidth:10 borderColor:[UIColor brownColor] image:nil andOpacity:1];
    
    [self.modelHelper addElementModelwithX:100 Y:60 width:80 height:100 color:[UIColor redColor] borderWidth:15 borderColor:[UIColor blackColor] image:nil andOpacity:0.5];
}

- (void) drawElements
{
    if (self.modelHelper.elements == nil)
        return;
    
    if (self.modelHelper.elements.count == 0)
        [self createInitialModel];
    
    // draw view for each element
    for (int i=0; i<self.modelHelper.elements.count; i++)
    {
        MPVImageScrollView * newView = [self imageScrollFromElementModel:self.modelHelper.elements[i]];
        newView.tag = i;
        [self.view addSubview:newView];
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
}

- (void)imageScrollViewTapped:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
{
    self.currentImageScrollView = senderView;
    [self callImagePicker];
//    CollageElementModel * model = self.modelHelper.elements[senderView.tag];
//    
//    if ([senderView hasImage])
//    {
//        [senderView removeImage];
//        [model removeImage];
//    }
//    else
//    {
//        UIImage * image = [UIImage imageNamed:imagefile];
//        [model setNewImage:image];
//        [senderView setImage:image WithPosition:CGPointMake(model.imageX, model.imageY) scale:model.imageScale andMinScale:[model minScaleToFitImage:image]];
//    }
}

- (void) imageScrollViewLongPress:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
{
    self.currentImageScrollView = senderView;
    
    UIMenuItem * item1 = [[UIMenuItem alloc] initWithTitle:@"change Image" action:@selector(changeImage:)];
    UIMenuItem * item2 = [[UIMenuItem alloc] initWithTitle:@"remove Image" action:@selector(removeImage:)];
    NSArray * menuItems = [NSArray arrayWithObjects:item1, item2, nil];
    
    [MPVLongPressMenu showMenu:recognizer forOwner:self withMenuItems:menuItems];

//    CollageElementModel * model = self.modelHelper.elements[senderView.tag];
//    
//    if ([senderView hasImage])
//    {
//        [senderView removeImage];
//    }
//    else
//    {
//        UIImage * image = [UIImage imageNamed:imagefile2];
//        [senderView setImage:image WithPosition:CGPointMake(model.imageX, model.imageY) scale:model.imageScale andMinScale:[model minScaleToFitImage:image]];
//        [model setNewImage:image];
//    }
}

- (void)changeImage:(id)sender
{
    [self callImagePicker];
}

- (void)removeImage:(id)sender
{
    CollageElementModel * model =  self.modelHelper.elements[self.currentImageScrollView.tag];
    [model removeImage];
    [self.currentImageScrollView removeImage];
    [self.currentImageScrollView tapEnable:YES];
    [self.currentImageScrollView longPressEnable:NO];
}

- (MPVImageScrollView *) imageScrollFromElementModel:(CollageElementModel *) model
{
    CGRect rect = CGRectMake(model.x, model.y, model.width, model.height);
    MPVImageScrollView * newView = [[MPVImageScrollView alloc] initWithFrame:rect];
    newView.elementDelegate = self;
    newView.backgroundColor = model.color;
    UIImage * image = [model getSavedImage];
    [newView setImage:image WithPosition:CGPointMake(model.imageX, model.imageY) scale:model.imageScale andMinScale:[model minScaleToFitImage:image]];
    
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
    [self.modelHelper updateElement:sender.tag Position:newPosition andScale:newScale];
}


// have method for this as apple decrees different ways to call from ipad and iphone
// This needs to be at a higher level view as should handle navigation.
// Makes this more complicated.
- (void) callImagePicker
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    imagePicker.delegate = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        //        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        //        [popover presentPopoverFromRect:self.baseView.bounds inView:self.collageBackgroundView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //        self.popOver = popover;
    } else
    {
        [self.parentViewController presentViewController:imagePicker animated:YES completion:nil];
    }
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image  = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CollageElementModel * model =  self.modelHelper.elements[self.currentImageScrollView.tag];
    [model setNewImage:image];
    
    [self.currentImageScrollView setImage:image WithPosition:CGPointMake(model.imageX, model.imageY) scale:model.imageScale andMinScale:[model minScaleToFitImage:image]];
    
    [self.currentImageScrollView tapEnable:NO];
    [self.currentImageScrollView longPressEnable:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL) canBecomeFirstResponder
{
    return YES;
}

@end
