////
////  MPVViewController.m
////  TryScrollView
////
////  Created by Manoj Patel on 12/12/13.
////  Copyright (c) 2013 Manoj Patel. All rights reserved.
////
//
//#import "MPVViewController.h"
//#import "MPVImageScrollView.h"
//
//@interface MPVViewController () <MPVElementDelegate>
//
//@property (weak, nonatomic) MPVImageScrollView * imageScrollView;
//
//@end
//
//@implementation MPVViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view, typically from a nib.
//    CGRect rect = CGRectMake(30, 60, self.view.bounds.size.width-60, self.view.bounds.size.height-90);
//    MPVImageScrollView * newView = [[MPVImageScrollView alloc]initWithFrame:rect];
//    newView.backgroundColor = [UIColor greenColor];
//    [newView setInternalScale:4];
//    [self.view addSubview:newView];
//    // maybe make this into a method, or set as part of init?
//    newView.elementDelegate = self;
//    [newView tapEnable:YES];
//    
//    self.imageScrollView = newView;
//    
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void) zoomChangedToScale:(float)newScale andOrigin:(CGPoint)newPosition sender:(MPVImageScrollView *)sender
//{
//    NSLog(@"scale: %f, origin: %f, %f", newScale, newPosition.x, newPosition.y);
//}
//
//- (IBAction)deleteImage:(id)sender
//{
//    [self.imageScrollView removeImage];
//}
//
//
//- (BOOL) canBecomeFirstResponder
//{
//    return YES;
//}
//
//- (void) imageScrollViewTapped:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
//{
//    UIImage * image = [UIImage imageNamed:@"concept.jpg"];
//    [senderView setImage:image WithPosition:CGPointMake(0, 0) scale:0.1 andMinScale:0.1];
//    [senderView tapEnable:NO];
//    [senderView longPressEnable:YES];
//}
//
//- (void) imageScrollViewLongPress:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
//{
//    [senderView removeImage];
//    [senderView tapEnable:YES];
//    [senderView longPressEnable:NO];
//}
//@end
