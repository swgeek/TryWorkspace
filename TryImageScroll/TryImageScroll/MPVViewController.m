//
//  MPVViewController.m
//  TryScrollView
//
//  Created by Manoj Patel on 12/12/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVViewController.h"
#import "MPVImageScrollView.h"

@interface MPVViewController () <MPVImageScrollDelegate>

@property (weak, nonatomic) MPVImageScrollView * imageScrollView;

@end

@implementation MPVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect rect = CGRectMake(30, 60, self.view.bounds.size.width-60, self.view.bounds.size.height-90);
    MPVImageScrollView * newView = [[MPVImageScrollView alloc]initWithFrame:rect];
    newView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:newView];
    // maybe make this into a method, or set as part of init?
    newView.delegate = self;
    [newView tapEnable:YES];
    
    self.imageScrollView = newView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) zoomChangedToScale:(float)newScale andOrigin:(CGPoint)newPosition sender:(MPVImageScrollView *)sender
{
    NSLog(@"scale: %f, origin: %f, %f", newScale, newPosition.x, newPosition.y);
}

- (IBAction)deleteImage:(id)sender
{
    [self.imageScrollView removeImage];
}


- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) imageScrollViewTapped:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
{
    UIImage * image = [UIImage imageNamed:@"concept.jpg"];
    [senderView setImage:image WithPosition:CGPointZero scale:0.3 minScale:0.05 andMaxScale:2];
    [senderView tapEnable:NO];
    [senderView longPressEnable:YES];
}

- (void) imageScrollViewLongPress:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
{
    [senderView removeImage];
    [senderView tapEnable:YES];
    [senderView longPressEnable:NO];
}

                           
                           
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaleBy:(float)scale
{
    CGSize targetSize = CGSizeMake(sourceImage.size.width * scale, sourceImage.size.height * scale);
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaledWidth = targetSize.width;
    CGFloat scaledHeight = targetSize.height;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        // make image center aligned
        // Check if need this! Probably not, using same ratios
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    return newImage ;
}

@end
