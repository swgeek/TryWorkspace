//
//  MPVCollageModel.h
//  MPVCollageElementModel
//
//  Created by Manoj Patel on 1/11/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MPVCollageElementModel;

@interface MPVCollageModel : NSManagedObject

@property (nonatomic, retain) NSData * backgroundColorData;
@property (nonatomic, retain) NSData * globalBorderColorData;
@property (nonatomic) float globalBorderHeight;
@property (nonatomic) float globalBorderWidth;
@property (nonatomic) float height;
@property (nonatomic) float width;
@property (nonatomic, retain) NSSet *elements;
@end

@interface MPVCollageModel (CoreDataGeneratedAccessors)

- (void)addElementsObject:(MPVCollageElementModel *)value;
- (void)removeElementsObject:(MPVCollageElementModel *)value;
- (void)addElements:(NSSet *)values;
- (void)removeElements:(NSSet *)values;

@end
