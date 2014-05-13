//
//  MPVLongPressMenu.h
//  MPVLongPressMenu
//
//  Created by Manoj Patel on 12/25/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//
// convenience class to add a menu to any object

#import <Foundation/Foundation.h>

@interface MPVLongPressMenu : NSObject

+ (void) addLongPressMenuTo: (UIView *)view withTarget:(id)target action:(SEL)selector;
+ (void)showMenu:(UIGestureRecognizer *)sender forOwner:(id)owner withMenuItems:(NSArray *)menuItems;

- (void) addMenuItemWithTitle:(NSString *)title andAction:(SEL)selector;
- (void)showMenu:(UIGestureRecognizer *)sender forOwner:(id)owner;

@end
