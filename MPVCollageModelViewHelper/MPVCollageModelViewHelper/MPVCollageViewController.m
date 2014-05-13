//
//  MPVCollageViewController.m
//  tryCollageView
//
//  Created by Manoj Patel on 1/29/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import "MPVCollageViewController.h"
#import "MPVCollageModelViewHelper.h"
#import "MPVUtilities.h"
#import "MPVCollagePreviewViewController.h"

@interface MPVCollageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MPVModelViewHelperDelegate>

@property (strong, nonatomic) UIView * collageView;
@property (strong, nonatomic) MPVCollageModelViewHelper * modelViewHelper;

@end

@implementation MPVCollageViewController

- (id) initWithCollageView:(UIView *)collageView andModelHelper:(MPVCollageModelViewHelper *)modelViewHelper
{
    self = [super init];
    if (self)
    {
        self.collageView = collageView;
        self.modelViewHelper = modelViewHelper;
        self.modelViewHelper.delegate = self;
        [self centerCollage];
        [self.view addSubview:collageView];
        [self addBarButtons];
        // don't want navigation bar to hide part of my collage
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    UIImage * image = [self.modelViewHelper imageWithLongEdge:2100];
    MPVCollagePreviewViewController * previewVC = [[MPVCollagePreviewViewController alloc] initWithFrame:self.view.bounds andImage:image];
    [self.navigationController pushViewController:previewVC animated:YES];
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

@end
