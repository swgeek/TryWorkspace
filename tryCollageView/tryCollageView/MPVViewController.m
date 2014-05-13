//
//  MPVViewController.m
//  tryCollageView
//
//  Created by Manoj Patel on 2/19/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import "MPVTemplateCell.h"
#import "MPVCollageModelViewHelper.h"
#import "MPVViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MPVUtilities.h"
#import "MPVCollagePreviewViewController.h"
#import "MPVCollageViewController.h"
#import "MPVCollageModelHelper.h"


@interface MPVViewController () <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) MPVCollageModelViewHelper * modelViewHelper;
@property (strong, nonatomic) UIView * collageView;

@property (nonatomic, strong) IBOutlet UICollectionView * collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout * flowLayout;

@end

@implementation MPVViewController

NSString * dataStoreFilename = @"trythis19";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modelViewHelper = [[MPVCollageModelViewHelper alloc] init];

    // don't want navigation bar to hide part of my collage
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [MPVCollageModelHelper getCollageFromDocument:dataStoreFilename withCompletionHandler:^(MPVCollage * collage){ [self collageModelReady:collage];
    }];

}

- (void) collageModelReady:(MPVCollage * )collage
{
    self.collageView  = [self.modelViewHelper createCollageView:collage];
    [self collageViewReadyToShow:self.collageView];
}










//- (void) initModelViewHelper
//{
//    self.modelViewHelper = [[MPVCollageModelViewHelper alloc] init];
//
//    // don't want navigation bar to hide part of my collage
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//
//    [MPVCollageModelHelper getCollageFromDocument:dataStoreFilename withCompletionHandler:[self ]
//    [self.modelViewHelper getCollageFromDataFile:dataStoreFilename withCompletionHandler:^(UIView * collageView)
//     {
//         [self collageViewReadyToShow:collageView];
//     }];
//}

- (void) collageViewReadyToShow:(UIView *) collageView
{
    self.collageView = collageView;
    [self templateListReadyToShow];
}

- (void) templateListReadyToShow
{
    //Have to figure out application flow. The model stuff should probably be in app delegate,
    // but leave it here for now.
    // todo: show a temporary splash screen until this is called, then show the collection.
    // pass in a list of templates, or figure out some other way
    [self initCollectionView];
}


- (void) initCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setItemSize:CGSizeMake(100, 100)];


    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];


    self.collectionView.backgroundColor = [UIColor greenColor];

    [self.collectionView registerClass:[MPVTemplateCell class] forCellWithReuseIdentifier:@"MPVTemplateCell"];

    [self.collectionView setCollectionViewLayout:self.flowLayout];

    self.collectionView.delegate = self;

    self.collectionView.dataSource = self;

    [self.view addSubview:self.collectionView];
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


- (void) addBarButtons
{
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Help"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(helpDialog:)];
    
    self.navigationItem.rightBarButtonItem = helpButton;
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:helpButton,nil];
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

#pragma mark - UICollectionView DataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    MPVTemplateCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MPVTemplateCell" forIndexPath:indexPath];
    if ([indexPath row] < 1)
        [cell addTemplateView: self.collageView];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPVCollageViewController * vc = [[MPVCollageViewController alloc] initWithCollageView:self.collageView andModelHelper:self.modelViewHelper];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(100, 100);
    return size;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}


@end
