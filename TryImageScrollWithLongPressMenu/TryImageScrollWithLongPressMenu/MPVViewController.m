//
//  MPVViewController.m
//  TryImageScrollWithLongPressMenu
//
//  Created by Manoj Patel on 12/25/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVViewController.h"
#import "MPVImageScrollView.h"
#import "MPVLongPressMenu.h"

@interface MPVViewController () <MPVImageScrollDelegate>

@property (weak, nonatomic) MPVImageScrollView * imageScrollView;

@property (strong, nonatomic) NSArray * menuItems;

@end

@implementation MPVViewController

- (NSArray *)menuItems
{
    if (! _menuItems)
    {
        UIMenuItem * item1 = [[UIMenuItem alloc] initWithTitle:@"remove image" action:@selector(removeImage:)];
        UIMenuItem * item2 = [[UIMenuItem alloc] initWithTitle:@"reload image" action:@selector(reloadImage:)];
        _menuItems = [NSArray arrayWithObjects:item1, item2, nil];
    }
    return _menuItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect rect = CGRectMake(30, 60, self.view.bounds.size.width-60, self.view.bounds.size.height-90);
    MPVImageScrollView * newView = [[MPVImageScrollView alloc]initWithFrame:rect];
    [self.view addSubview:newView];
    newView.delegate = self;
    
    UIImage * image = [UIImage imageNamed:@"concept.jpg"];
    [newView setImage:image WithPosition:CGPointZero scale:1 minScale:0.1 andMaxScale:2];

    self.imageScrollView = newView;

    [self.imageScrollView longPressEnable:YES];
}

#pragma long press menu methods

- (void) imageScrollViewLongPress:(UIGestureRecognizer *)recognizer fromView:(MPVImageScrollView *)senderView
{
    [self showMenu:recognizer];
}

// could move all or part of this into a utility class
// special project just for menu seems overkill
- (void)showMenu:(UIGestureRecognizer *)sender
{
    if (![self becomeFirstResponder])
    {
        NSLog(@"couldn't become first responder");
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    [menu setMenuItems:self.menuItems];
    
    CGPoint location = [sender locationInView:[sender view]];
    
    [menu setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[sender view]];
    
    [menu setMenuVisible:YES animated:YES];
}


- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void)removeImage:(id)sender
{
    [self.imageScrollView removeImage];
}

- (void)reloadImage:(id)sender
{
    UIImage * image = [UIImage imageNamed:@"concept.jpg"];

    [self.imageScrollView setImage:image WithPosition:CGPointZero scale:0.3 minScale:0.1 andMaxScale:2];
}

#pragma imagescroll methods

- (void) zoomChangedToScale:(float)newScale andOrigin:(CGPoint)newPosition sender:(MPVImageScrollView *)sender
{
    NSLog(@"scale: %f, origin: %f, %f", newScale, newPosition.x, newPosition.y);
}

@end
