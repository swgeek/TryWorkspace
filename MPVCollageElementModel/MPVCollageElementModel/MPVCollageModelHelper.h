//
//  MPVCollageModelHelper.h
//  MPVCollageElementModel
//
//  Created by Manoj Patel on 12/31/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//
// opens and reads the core data file.
// holds onto the context and the objects retrieved from core data so acts as the interface
// between the user and the core data objects.

#import <Foundation/Foundation.h>

@class MPVCollage;
@class MPVCollageModel;
@class MPVCollageElementModel;

@interface MPVCollageModelHelper : NSObject

//- (id) initWithDocumentUrl:(NSURL *) url andCompletionHandler:(void(^)(MPVCollage * collage)) completionHandler;
+ (void) getCollageFromDocument:(NSString *) fileName withCompletionHandler:(void(^)(MPVCollage * collage))completionHandler;


- (MPVCollageModel *) createNewCollageModelWithWidth:(float) width
                                              height:(float)height
                                     backgroundColor:(UIColor *)color
                                   globalborderWidth:(float)borderWidth
                                   globalborderColor:(UIColor *)borderColor;

- (MPVCollageElementModel *) createNewElementWithX:(float) x
                                                 Y:(float)y
                                             width:(float) width
                                            height:(float)height
                                             color:(UIColor *)color
                                       borderWidth:(float)borderWidth
                                       borderColor:(UIColor *)borderColor
                                           opacity:(float)opacity
                                          andIndex:(int)index;

- (MPVCollage *) initializeExampleCollage;
@end
