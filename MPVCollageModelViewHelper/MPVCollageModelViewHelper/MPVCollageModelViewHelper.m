//
//  MPVCollageModelViewHelper.m
//  MPVCollageModelViewHelper
//
//  Created by Manoj Patel on 1/3/14.
//  Copyright (c) 2014 Manoj Patel. All rights reserved.
//

#import "MPVCollageModelViewHelper.h"
#import "MPVCollageView.h"
#import "MPVCollageModelHelper.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MPVUtilities.h"
#import "MPVCollage.h"
#import "MPVElement.h"
#import "UIImage+Resize.h"

@interface MPVCollageModelViewHelper() <MPVCollageViewDelegate>

@property (strong, nonatomic) MPVCollageModelHelper * modelHelper;
@property (strong, nonatomic) MPVCollage * collage;
@property (strong, nonatomic) MPVCollageView * collageView;
@property (nonatomic) NSInteger currentTag;
@end

@implementation MPVCollageModelViewHelper


// this has to be done at view controller level as calls drawelements, but should
// split up so can start at app delegate level. Get it working for now, will fix later.

// logically, should split up anyway. Get the model from the data file then decide what to do with it, do not tie it to a view.
//- (void) getCollageFromDataFile:(NSString *) dataStoreFilename withCompletionHandler:(void(^) (UIView * collageView)) completionHandler
//{
//    NSURL * url = [MPVUtilities GetDocumentFileUrl:dataStoreFilename];
//    self.modelHelper = [[MPVCollageModelHelper alloc] initWithDocumentUrl:url andCompletionHandler:^(MPVCollage * collage) {
//        MPVCollageView * cView = [self drawElements:collage];
//        completionHandler(cView);
//    }];
//}


- (MPVCollage *) createInitialModel
{
    MPVCollage * collage = [self.modelHelper initializeExampleCollage];
    return collage;
}

// was: - (MPVCollageView *) drawElements: (MPVCollage *) collage
- (UIView *) createCollageView:(MPVCollage *)collageModel
{
    
    if (! collageModel)
        return nil;
    
    self.collage = collageModel;
    
    CGRect rect = CGRectMake(0, 0, self.collage.width, self.collage.height);

    self.collageView = [[MPVCollageView alloc] initWithFrame:rect andDelegate:self];
    self.collageView.backgroundColor = self.collage.backgroundColor;
    self.collageView.globalBorderColor = self.collage.globalBorderColor;
    self.collageView.globalBorderWidth = self.collage.globalBorderWidth;

    [self addElementsToView];
    
    return self.collageView;
}


- (void) addElementsToView
{
    // draw view for each element. Draw in order, back to front, in case of overlap
    for (int i=0; i<self.collage.elementCount; i++)
    {
        MPVElement * model = [self.collage elementAtIndex:i];
 
        // common code here, abstract it out
        UIImage * imageToUse = model.image;
        
        // skip thumbnail stuff for now, but add it later
        
        // TODO:HAVE TO FIGURE OUT THE SCALE STUFF HERE. UGH! How to do that?
        [self.collageView addElementWithX:model.x
                                        Y:model.y
                                    width:model.width
                                   height:model.height
                                    color:model.color
                              borderWidth:model.borderWidth
                              borderColor:model.borderColor
                                    image:imageToUse
                                   imageX:model.imageX
                                   imageY:model.imageY
                               imageScale:model.imageScale
                    thumbnailToImageScale:1
                                 minScale:[model minScaleToFitImage:model.image]
                                  opacity:model.opacity
                                   andTag:i];
    }
}

- (void) elementTapped:(UIGestureRecognizer *)recognizer senderTag:(NSInteger)tag
{
    self.currentTag = tag;
    [self callImagePicker];
}

- (void) elementLongPress:(UIGestureRecognizer *)recognizer senderTag:(NSInteger)tag
{
    self.currentTag = tag;
    
    UIMenuItem * item1 = [[UIMenuItem alloc] initWithTitle:@"change Image" action:@selector(changeImage:)];
    UIMenuItem * item2 = [[UIMenuItem alloc] initWithTitle:@"remove Image" action:@selector(removeImage:)];
    NSArray * menuItems = [NSArray arrayWithObjects:item1, item2, nil];
    
    [MPVUtilities showMenu:recognizer forOwner:[self topViewController] withMenuItems:menuItems];
}

- (void)changeImage:(id)sender
{
    [self callImagePicker];
}

- (void)removeImage:(id)sender
{
    MPVElement * element = [self.collage elementAtIndex:self.currentTag];
    [element removeImage];
    [self.collageView removeImageFromElement:self.currentTag];
}

- (void) zoomChangedToScale:(float)newScale andOrigin:(CGPoint)newPosition senderTag:(NSInteger)tag
{
    [[self.collage elementAtIndex:tag] updateImagePosition:newPosition andScale:newScale];
}


// Not sure if this is accepted practice or not, but prefer this to passing in the parent
// view controller and having a circular reference. May change my mind, not sure.
// the other option is to create a viewcontroller for this view, or even do away with the helper
// and have all this at the top level
// If use a delegate, use a protocol so don't have a really bad circular reference.
-  (UIViewController *) topViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

// have method for this as apple decrees different ways to call from ipad and iphone
// This needs to be at a higher level view as should handle navigation.
// Makes this more complicated.
- (void) callImagePicker
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    imagePicker.delegate = self.delegate;
        
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        //        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        //        [popover presentPopoverFromRect:self.baseView.bounds inView:self.collageBackgroundView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //        self.popOver = popover;
    } else
    {
        
        [[self topViewController] presentViewController:imagePicker animated:YES completion:nil];
    }
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image  = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    MPVElement * element = [self.collage elementAtIndex:self.currentTag];

    [element setNewImage:image];
    UIImage * imageToUse = element.image;

    [self.collageView setImage:imageToUse withThumbnailToImageScale:1 X:element.imageX Y:element.imageY scale:element.imageScale minScale:[element minScaleToFitImage:image] forElement:self.currentTag];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *) imageWithLongEdge:(float)longEdge
{
    if (! self.modelHelper)
        return nil;
    UIImage * image = [self imageForView:[self createPreviewWithLongEdge:longEdge]];
    return image;
}

// move this to utilities? not specific to this class
- (UIImage *)imageForView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retval;
}

// a lot of this code is duplicated in CollageView, combine
- (UIView *) createPreviewWithLongEdge:(float)longEdge
{
    if (longEdge <1)
        return nil;
    
    float collageLongEdge = MAX(self.collage.width, self.collage.height);
    float scale = longEdge/collageLongEdge;
    
    CGRect rect = CGRectMake(0, 0, self.collage.width * scale, self.collage.height * scale);
    UIView * view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = self.collage.backgroundColor;
    
    // render each element into collage
    // draw view for each element. Draw in order, back to front, in case of overlap
    for (int i=0; i<self.collage.elementCount; i++)
    {
        MPVElement * model = [self.collage elementAtIndex:i];
        CGRect elementRect = CGRectMake(model.x * scale, model.y * scale, model.width * scale, model.height * scale);
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:elementRect];
        imageView.backgroundColor = model.color;
        
        if ((model.borderWidth <0) && (self.collage.globalBorderWidth >= 0))
        {
            imageView.layer.borderWidth = self.collage.globalBorderWidth * scale;
            imageView.layer.borderColor = [self.collage.globalBorderColor CGColor];
        }
        else
        {
            imageView.layer.borderColor = [model.borderColor CGColor];
            imageView.layer.borderWidth = model.borderWidth * scale;
        }
        
        if (model.opacity < 1) // should I add a delta for rounding error?
            imageView.opaque = YES;
        else
            imageView.opaque = NO;
        
        imageView.alpha = model.opacity;
        
        if (model.image)
        {
            UIImage * imageToUse = model.image;
            CGSize newSize = model.image.size;
            newSize.height *= model.imageScale * scale;
            newSize.width *= model.imageScale * scale;
            
            UIImage * resizedImage = [MPVUtilities resizeImage:imageToUse toSize:newSize withInterpolationQuality:kCGInterpolationHigh];
            
            CGRect cropRect = CGRectMake(model.imageX * scale, model.imageY * scale, elementRect.size.width, elementRect.size.height);
            CGImageRef imageRef = CGImageCreateWithImageInRect([resizedImage CGImage], cropRect);
            UIImage * croppedImage = [UIImage imageWithCGImage:imageRef];
            imageView.image = croppedImage;
        }
        
        [view addSubview:imageView];
    }
    
    return view;
}


@end
