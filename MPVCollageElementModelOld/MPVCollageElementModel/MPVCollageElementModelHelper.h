//
//  MPVCollageElementModelHelper.h
//  TryElementModel
//
//  Created by Manoj Patel on 12/19/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPVCollageElementModelHelper : NSObject

@property (strong, nonatomic) NSArray * elements; // type CollageElementModel

- (id) initWithDocumentUrl:(NSURL *) documentURL andCompletionHandler:(void(^)()) completionHandler;

- (void) addElementModelwithX:(float) x
                            Y:(float)y
                        width:(float) width
                       height:(float)height
                        color:(UIColor *)color
                  borderWidth:(float)borderWidth
                  borderColor:(UIColor *)borderColor
                        image:(UIImage *)image
                   andOpacity:(float)opacity;

+ (UIManagedDocument *) createOrOpenManagedDocumentWithUrl:(NSURL *)url CompletionHandler:(void(^)(BOOL success)) completionHandler;

// for test only, core data autosaves
-(void) save:(NSURL *)url;

@end
