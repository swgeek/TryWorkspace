//
//  MPVCollageModel+Convenience.m
//  MPVCollageElementModel
//
//  Created by Manoj Patel on 12/30/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVCollageModel+Convenience.h"
#import "MPVCollageElementModel+Convenience.h"
#import "MPVUtilities.h"

@implementation MPVCollageModel (Convenience)

NSString * collageClassName = @"MPVCollageModel";

- (NSInteger) elementCount
{
    return self.elements.count;
}

- (UIColor *) backgroundColor
{
    return [MPVUtilities ColorFromData:self.backgroundColorData];
}

- (void) setBackgroundColor:(UIColor *)color
{
    self.backgroundColorData = [MPVUtilities DataFromColor:color];
}

- (UIColor *) globalBorderColor
{
    return [MPVUtilities ColorFromData:self.globalBorderColorData];
}

- (void) setGlobalBorderColor:(UIColor *)color
{
    self.globalBorderColorData = [MPVUtilities DataFromColor:color];
}

- (MPVCollageElementModel *) elementAtIndex:(NSInteger)index
{
    MPVCollageElementModel * returnValue = nil;
    
    for (MPVCollageElementModel * model in self.elements)
    {
        if (model.index == index)
            returnValue = model;
    }
    return returnValue;
}

// returns index
- (NSInteger) addElementModelwithX:(float) x
                            Y:(float)y
                        width:(float) width
                       height:(float)height
                        color:(UIColor *)color
                  borderWidth:(float)borderWidth
                  borderColor:(UIColor *)borderColor
                   andOpacity:(float)opacity
{
    MPVCollageElementModel * newElement = [NSEntityDescription insertNewObjectForEntityForName:elementClassName inManagedObjectContext:self.managedObjectContext];
    
    newElement.x = x;
    newElement.y = y;
    newElement.width = width;
    newElement.height = height;
    newElement.color = color;
    newElement.borderWidth = borderWidth;
    newElement.borderColor = borderColor;
    newElement.opacity = opacity;
    newElement.index = self.elements.count;
    
    // new elements do not have an image, must be added later
    
    [self addElementsObject:newElement];
    return newElement.index;
}


@end
