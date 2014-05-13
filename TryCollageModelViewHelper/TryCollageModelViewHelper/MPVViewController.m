//
//  MPVViewController.m
//  TryCollageModelViewHelper
//
//  Created by Manoj Patel on 1/21/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import "MPVViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MPVCollageModelViewHelper.h"
#import "MPVUtilities.h"
#import "MPVCollage.h"
#import "MPVCollageModelHelper.h"

@interface MPVViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MPVModelViewHelperDelegate>

@property (strong, nonatomic) MPVCollageModelViewHelper * modelViewHelper;
@property (strong, nonatomic) UIView * collageView;

@end

@implementation MPVViewController

NSString * dataStoreFilename = @"trythis07";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modelViewHelper = [[MPVCollageModelViewHelper alloc] init];
    self.modelViewHelper.delegate = self;

    [MPVCollageModelHelper getCollageFromDocument:dataStoreFilename withCompletionHandler:^(MPVCollage * collage){ [self collageModelReady:collage];
    }];
    
    // don't want navigation bar to hide part of my collage
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void) collageModelReady:(MPVCollage * )collage
{
    self.collageView  = [self.modelViewHelper createCollageView:collage];
    [self centerCollage];
    [self.view addSubview:self.collageView];
    [self addBarButtons];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.modelViewHelper imagePickerController:picker didFinishPickingMediaWithInfo:info];
}

- (void)changeImage:(id)sender
{
    [self.modelViewHelper changeImage:sender];
}

- (void)removeImage:(id)sender
{
    [self.modelViewHelper removeImage:sender];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io {
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [MPVUtilities setScaleAndCenterTransforms:self.collageView toRect:self.view.bounds withMargin:20];
}

- (void) centerCollage
{
    if (self.collageView)
        [MPVUtilities setScaleAndCenterTransforms:self.collageView toRect:self.view.bounds withMargin:20];
}

- (void) addBarButtons
{
    // update to ask if leaves preview without saving? Not sure...
    // maybe skip preview, just save? Not sure.
    // For now, preview
    UIBarButtonItem *previewButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Preview and Save"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(previewImage:)];
    
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Help"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(helpDialog:)];
    
    self.navigationItem.rightBarButtonItem = previewButton;
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:helpButton,previewButton,nil];
}

- (IBAction)previewImage:(id)sender
{
}

- (IBAction)helpDialog:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Info"
                                                      message:@"help message here"
                                                     delegate: nil
                                            cancelButtonTitle:@"ok"
                                            otherButtonTitles:nil];
    [message show];
    
}

// move this to utilities? not specific to this class
- (UIImage *)imageForView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retval;
}

@end
