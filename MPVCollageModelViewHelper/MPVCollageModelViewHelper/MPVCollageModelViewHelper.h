//
//  MPVCollageModelViewHelper.h
//  MPVCollageModelViewHelper
//
//  Created by Manoj Patel on 1/3/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MPVModelViewHelperDelegate <NSObject>

// call corresponding method here in this method
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)changeImage:(id)sender;
- (void)removeImage:(id)sender;

@end

@class MPVCollageView;
@class MPVCollage;

@interface MPVCollageModelViewHelper : NSObject

@property (strong, nonatomic) id<MPVModelViewHelperDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> delegate;

//- (void) getCollageFromDataFile:(NSString *) dataStoreFilename withCompletionHandler:(void(^) (UIView * collageView)) completionHandler;

- (UIView *)createCollageView: (MPVCollage *)collageModel;

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

- (void)changeImage:(id)sender;
- (void)removeImage:(id)sender;

- (UIImage *) imageWithLongEdge:(float)longEdge;

@end
