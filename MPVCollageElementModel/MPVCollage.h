//
//  MPVCollage.h
//  MPVCollageModelViewHelper
//
//  Created by Manoj Patel on 1/6/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPVElement;
@class MPVCollageModelHelper;
@class MPVCollageModel;

@interface MPVCollage : NSObject

@property (nonatomic, strong, readonly) UIColor * backgroundColor;
@property (nonatomic, strong, readonly) UIColor * globalBorderColor;
@property (nonatomic, readonly) float globalBorderHeight;
@property (nonatomic, readonly) float globalBorderWidth;
@property (nonatomic, readonly) float height;
@property (nonatomic, readonly) float width;


- (id) initWithCollageModel: (MPVCollageModel *) model;

- (MPVElement *) elementAtIndex:(NSInteger)index;

- (int) elementCount;
@end
