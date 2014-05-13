//
//  MPVCollagePreviewViewController.m
//  tryCollageView
//
//  Created by Manoj Patel on 1/18/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import "MPVCollagePreviewViewController.h"
#import "MPVImageScrollView.h"
#import "MPVUtilities.h"

@interface MPVCollagePreviewViewController () <MPVImageScrollDelegate>

@property (strong, nonatomic) MPVImageScrollView * scrollView;
@property (strong, nonatomic) UIImage * image;

@end

@implementation MPVCollagePreviewViewController

- (id) initWithFrame:(CGRect)rect andImage: (UIImage *) image
{
    self = [super init];
    if (self)
    {
        self.view = [[UIView alloc] initWithFrame:rect];
        self.view.backgroundColor = [UIColor whiteColor];
        
        CGRect scrollViewRect = [self rectToFitRatio:image.size.height/image.size.width intoRect:rect];
        self.scrollView = [[MPVImageScrollView alloc] initWithFrame:scrollViewRect];
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
        [self centerView];
        [self.scrollView centerAndFitImage:image];
        // don't want navigation bar to hide part of my collage
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.image = image;
        UIBarButtonItem *exportButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Save"
                                         style:UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(exportImage:)];
        
        self.navigationItem.rightBarButtonItem = exportButton;
   }
    
    return self;
}

-(CGRect) rectToFitRatio:(float)ratio intoRect:(CGRect)rect
{
    CGSize insideRectSize = CGSizeMake(rect.size.width, rect.size.width * ratio);
    float scale = [MPVUtilities getScaleToFitSize:insideRectSize intoSize:rect.size withMargin:0];
    return CGRectMake(0, 0, rect.size.width * scale, rect.size.width * scale * ratio);
}

// why is this not called?
- (void)viewDidLoad
{
    [super viewDidLoad];

 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) zoomChangedToScale:(float)newScale andOrigin:(CGPoint)newPosition sender:(MPVImageScrollView *)sender
{
    
}

- (void) centerView
{
    if (self.scrollView)
        [MPVUtilities setScaleAndCenterTransforms:self.scrollView toRect:self.view.bounds withMargin:0];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io {
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self centerView];
}

- (IBAction)exportImage:(id)sender
{
    [MPVUtilities saveCollageToCameraRoll:self.image];
}

@end
