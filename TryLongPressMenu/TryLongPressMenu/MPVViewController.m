//
//  MPVViewController.m
//  TryLongPressMenu
//
//  Created by Manoj Patel on 12/25/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVViewController.h"
#import "MPVLongPressMenu.h"

@interface MPVViewController ()

@end

@implementation MPVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = CGRectMake(50, 50, 150, 150);
    UIView * newView = [[UIView alloc]initWithFrame:rect];
    newView.backgroundColor = [UIColor greenColor];
    [MPVLongPressMenu addLongPressMenuTo:newView withTarget:self action:@selector(showMenu:)];
    [self.view addSubview:newView];
    
    CGRect rect2 = CGRectMake(50, 250, 150, 150);
    UIView * newView2 = [[UIView alloc]initWithFrame:rect2];
    newView2.backgroundColor = [UIColor blueColor];
    [MPVLongPressMenu addLongPressMenuTo:newView2 withTarget:self action:@selector(showMenuVersion2:)];
    [self.view addSubview:newView2];
}

- (void)showMenu:(UIGestureRecognizer *)sender
{
    UIMenuItem * item1 = [[UIMenuItem alloc] initWithTitle:@"do thing1" action:@selector(doThing1:)];
    UIMenuItem * item2 = [[UIMenuItem alloc] initWithTitle:@"do thing2" action:@selector(doThing2:)];
    NSArray * menuItems = [NSArray arrayWithObjects:item1, item2, nil];
    
    [MPVLongPressMenu showMenu:sender forOwner:self withMenuItems:menuItems];
}


- (void)showMenuVersion2:(UIGestureRecognizer *)sender
{
    MPVLongPressMenu * menuHelper = [[MPVLongPressMenu alloc]init];
    [menuHelper addMenuItemWithTitle:@"do thing2" andAction:@selector(doThing2:)];
    [menuHelper addMenuItemWithTitle:@"do thing3" andAction:@selector(doThing3:)];
    
    [menuHelper showMenu:sender forOwner:self];
}

- (void)doThing1:(id)sender
{
}

- (void)doThing2:(id)sender
{
}

- (void)doThing3:(id)sender
{
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}


@end
