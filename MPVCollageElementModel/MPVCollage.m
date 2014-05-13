//
//  MPVCollage.m
//  MPVCollageModelViewHelper
//
//  Created by Manoj Patel on 1/6/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//
// Collage Model, but using this instead of CollageModel directly as Core Data
// is a pain to work with and to debug
// maybe extend as an interface, so holds both the view and the model

#import "MPVCollage.h"
#import "MPVElement.h"
#import "MPVCollageModelHelper.h"
#import "MPVCollageModel+Convenience.h"
#import "MPVCollageElementModel+Convenience.h"

@interface MPVCollage()

@property (nonatomic, strong, readwrite) UIColor * backgroundColor;
@property (nonatomic, strong, readwrite) UIColor * globalBorderColor;
@property (nonatomic, readwrite) float globalBorderHeight;
@property (nonatomic, readwrite) float globalBorderWidth;
@property (nonatomic, readwrite) float height;
@property (nonatomic, readwrite) float width;

@property (nonatomic, retain) NSMutableArray * elements; // of MPVElement
@property (nonatomic, strong) MPVCollageModel * collageModel;

@end

@implementation MPVCollage

- (id) initWithCollageModel: (MPVCollageModel *) model
{
    self = [super init];
    if (self)
    {
        if (! model)
            self = nil;
        else
        {
            self.width = model.width;
            self.height = model.height;
            self.backgroundColor = model.backgroundColor;
            self.globalBorderColor = model.globalBorderColor;
            self.globalBorderWidth = model.globalBorderWidth;
            self.collageModel = model;
            
            self.elements = [[NSMutableArray alloc] init];
            // make sure elements is correct size
            for (int i=0; i<model.elementCount; i++)
                 [self.elements addObject:[NSNull null]];
            
             for (MPVCollageElementModel * elementModel in model.elements)
            {
                MPVElement * element = [[MPVElement alloc] initWithElementModel:elementModel];
                [self.elements setObject:element atIndexedSubscript:element.index];
            }
        }
    }
    return self;
}

- (MPVElement *) elementAtIndex:(NSInteger)index
{
    if (index >= self.elements.count)
        return nil;
    
    return self.elements[index];
}

- (int) elementCount
{
    return (int)self.elements.count;
}

@end
