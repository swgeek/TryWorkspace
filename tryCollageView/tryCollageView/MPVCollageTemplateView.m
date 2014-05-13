//
//  MPVCollageTemplateView.m
//  tryCollageView
//
//  Created by Manoj Patel on 1/30/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//
// This is temporary code! uses both model and view in one, separate out into model, view, and helper.
// most of the code here will be helper.

#import "MPVCollageTemplateView.h"
#import "MPVCollage.h"

@implementation MPVCollageTemplateView

// temporary, use CollageTemplateModel instead of collage model
- (id)initWithFrame:(CGRect)frame andCollage:(MPVCollage *)collage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
