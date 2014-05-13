//
//  MPVLongPressMenu.m
//  MPVLongPressMenu
//
//  Created by Manoj Patel on 12/25/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVLongPressMenu.h"

@interface MPVLongPressMenu()
@property (strong, nonatomic) NSMutableArray * menuItems;
@end

@implementation MPVLongPressMenu

- (NSMutableArray *)menuItems
{
    if (! _menuItems)
        _menuItems = [[NSMutableArray alloc]init];
    return _menuItems;
}

+ (void) addLongPressMenuTo: (UIView *)view withTarget:(id)target action:(SEL)selector
{
    UILongPressGestureRecognizer * recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    [view addGestureRecognizer:recognizer];
}

+ (void)showMenu:(UIGestureRecognizer *)sender forOwner:(id)owner withMenuItems:(NSArray *)menuItems
{
    if (sender.state != UIGestureRecognizerStateBegan)
        return;
    
    if (![owner becomeFirstResponder]) {
        NSLog(@"couldn't become first responder");
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    [menu setMenuItems:menuItems];
    
    CGPoint location = [sender locationInView:[sender view]];
    
    [menu setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[sender view]];
    
    [menu setMenuVisible:YES animated:YES];
}

- (void) addMenuItemWithTitle:(NSString *)title andAction:(SEL)selector
{
    UIMenuItem * menuItem = [[UIMenuItem alloc] initWithTitle:title action:selector];
    [self.menuItems addObject:menuItem];
}

- (void)showMenu:(UIGestureRecognizer *)sender forOwner:(id)owner
{
    [MPVLongPressMenu showMenu:sender forOwner:owner withMenuItems:self.menuItems];
}

@end
