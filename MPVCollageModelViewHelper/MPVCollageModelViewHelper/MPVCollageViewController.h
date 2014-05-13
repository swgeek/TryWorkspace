//
//  MPVCollageViewController.h
//  tryCollageView
//
//  Created by Manoj Patel on 1/29/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPVCollageModelViewHelper;

@interface MPVCollageViewController : UIViewController

- (id) initWithCollageView:(UIView *)collageView andModelHelper:(MPVCollageModelViewHelper *)modelViewHelper;

@end
