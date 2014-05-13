//
//  MPVCollageElementModel.h
//  MPVCollageElementModel
//
//  Created by Manoj Patel on 1/11/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MPVCollageModel;

@interface MPVCollageElementModel : NSManagedObject

@property (nonatomic, retain) NSData * borderColorData;
@property (nonatomic) float borderWidth;
@property (nonatomic, retain) NSData * colorData;
@property (nonatomic) float height;
@property (nonatomic, retain) NSString * imageFilename;
@property (nonatomic) float imageScale;
@property (nonatomic) float imageX;
@property (nonatomic) float imageY;
@property (nonatomic) int32_t index;
@property (nonatomic) float opacity;
@property (nonatomic, retain) NSString * thumbnailFilename;
@property (nonatomic) float thumbnailScale;
@property (nonatomic) float width;
@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic, retain) MPVCollageModel *collage;

@end
