//
//  CollageElementModel.h
//  TryElementModelWithImageScroll
//
//  Created by Manoj Patel on 12/26/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CollageElementModel : NSManagedObject

@property (nonatomic, retain) NSData * borderColorData;
@property (nonatomic) float borderWidth;
@property (nonatomic, retain) NSData * colorData;
@property (nonatomic) float height;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic) float imageScale;
@property (nonatomic) float imageX;
@property (nonatomic) float imageY;
@property (nonatomic) float opacity;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic) float thumbnailScale;
@property (nonatomic) float width;
@property (nonatomic) float x;
@property (nonatomic) float y;

@end
