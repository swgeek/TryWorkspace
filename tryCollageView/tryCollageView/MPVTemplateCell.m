//
//  MPVTemplateCell.m
//  tryCollageView
//
//  Created by Manoj Patel on 2/19/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import "MPVTemplateCell.h"
#import "MPVUtilities.h"

@interface MPVTemplateCell()

@property (nonatomic, strong) UILabel * label;

@end

@implementation MPVTemplateCell

- (UILabel *) label
{
    if (_label == nil)
        _label = [[UILabel alloc] initWithFrame:self.bounds];
    return _label;
}

- (void) setValue1:(int)value1
{
    if (value1 < 4)
    {
        self.label.text = [NSString stringWithFormat:@"%i", value1];
        [self.contentView addSubview:self.label];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void) addTemplateView:(UIView *)templateView
{
    // TODO: first clear old views
   [MPVUtilities setScaleAndCenterTransforms:templateView toRect:self.bounds withMargin:0];
   [self addSubview:templateView];
}

- (void) cleanup
{
    [self.label removeFromSuperview];
    self.label = nil;
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
