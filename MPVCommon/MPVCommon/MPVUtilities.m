//
//  MPVUtilities.m
//  MPVCommon
//
//  Created by Manoj Patel on 5/19/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVUtilities.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation MPVUtilities

// probably should not be here, maybe pass these values in
NSString * MPVkCollageArchiveFilename = @"collageArchive";

+ (UIColor *) colorFromHexString:(NSString *)colorString
{
    NSScanner * scanner = [NSScanner scannerWithString:colorString];
    uint rgbValue;
    [scanner scanHexInt:&rgbValue];
    UIColor * color =  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    return color;
}

+ (NSData *) DataFromColor:(UIColor *) color
{
    return [NSKeyedArchiver archivedDataWithRootObject:color];
}

+ (UIColor *) ColorFromData:(NSData *) colorData
{
    
    return (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
}

// image and view stuff

+ (void) setScaleAndCenterTransforms: (UIView *) childView toRect:(CGRect) parentRect withMargin:(float) margin
{
//    float maxDesiredHeight = parentRect.size.height - (margin * 2);
//    float subviewHeight = [childView bounds].size.height;
//    float heightRatio = maxDesiredHeight / subviewHeight;
//    
//    float maxDesiredWidth = parentRect.size.width - (margin * 2);
//    float subviewWidth = [childView bounds].size.width;
//    float widthRatio = maxDesiredWidth / subviewWidth;
//    
//    float ratio = MIN(heightRatio, widthRatio);
    
    float ratio = [MPVUtilities getScaleToFitSize:childView.bounds.size intoSize:parentRect.size withMargin:margin];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(ratio, ratio);

    // TODOTODO: THIS DOES NOT SEEM CORRECT, FIX IT!
    float maxDesiredHeight = parentRect.size.height - (margin * 2);
    float maxDesiredWidth = parentRect.size.width - (margin * 2);
    
    childView.center = CGPointMake(parentRect.origin.x + maxDesiredWidth/2 + margin, parentRect.origin.y + (maxDesiredHeight/2) + margin);
    
    childView.transform = transform;
}

+ (float) getScaleToFitSize:(CGSize) child intoSize:(CGSize)parent withMargin:(float)margin
{
    float maxDesiredHeight = parent.height - (margin * 2);
    float subviewHeight = child.height;
    float heightRatio = maxDesiredHeight / subviewHeight;
    
    float maxDesiredWidth = parent.width - (margin * 2);
    float subviewWidth = child.width;
    float widthRatio = maxDesiredWidth / subviewWidth;
    
    float ratio = MIN(heightRatio, widthRatio);
    
    return ratio;
}

+ (UIImage *) createThumbnail:(UIImage *)sourceImage withLongEdge:(float)longEdgeLength
{
    
    float imageLongestEdge = MAX(sourceImage.size.height, sourceImage.size.width);
    
    if (imageLongestEdge <= longEdgeLength)
        return sourceImage;
    
    float scale = longEdgeLength / imageLongestEdge;
    
    return [MPVUtilities imageWithImage:sourceImage scaleBy:scale];
}



+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize withInterpolationQuality:(CGInterpolationQuality)quality
{
    if (! image)
        return nil;
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // scale the image
    CGContextDrawImage(bitmap, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}


// file stuff
+ (NSString *)createPathForFilename:(NSString *)filename
{
    return [[self getCollageFolderPath] stringByAppendingPathComponent:filename];
}

// returns filename only, not full path (so can rename or move folder easily)
+ (NSString *) saveImage: (UIImage *) image
{
    // Ugh, hate compressing, wish could just copy original image
    //NSData *jpegImage = UIImageJPEGRepresentation(image, 0.85);
    
    // refactor, move both below lines to utilities?
    //NSString *fileName = [NSString stringWithFormat:@"%lf.jpg", [[NSDate date] timeIntervalSince1970]];
    //NSString *imageFilePath = [MPVUtilities createPathForFilename:fileName];
    //[jpegImage writeToFile:imageFilePath atomically:YES]; //Write the file

    
    // Ugh, hate compressing, wish could just copy original image
    NSData *pngImage = UIImagePNGRepresentation(image);
    
    // refactor, move both below lines to utilities?
    NSString *fileName = [NSString stringWithFormat:@"%lf.png", [[NSDate date] timeIntervalSince1970]];
    NSString *imageFilePath = [MPVUtilities createPathForFilename:fileName];
    [pngImage writeToFile:imageFilePath atomically:YES]; //Write the file
    
    
    return fileName;
}

+ (UIImage *) getImage: (NSString *) fileName
{
    NSString *imageFilePath = [MPVUtilities createPathForFilename:fileName];
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:imageFilePath];
    return image;
}

// will probably change this. Also, may combine with open
+ (NSURL *) GetDocumentFileUrl:(NSString *) documentName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL * url = [documentsDirectory URLByAppendingPathComponent:documentName];
    return url;
}

+ (void) removeFile: (NSString *) filename
{
    if (! filename)
        return;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *fullPath = [MPVUtilities createPathForFilename:filename];
    BOOL removeSuccess = [fileManager removeItemAtPath:fullPath error:&error];
    if (!removeSuccess)
    {
        NSLog(@"Could not delete file: %@", [error localizedDescription]);
    }
    
}

// pop up menu
+ (void)showMenu:(UIGestureRecognizer *)sender forOwner:(id)owner withMenuItems:(NSArray *)menuItems
{
    if (sender.state != UIGestureRecognizerStateBegan)
        return;
    
    if (![owner becomeFirstResponder]) {
        NSLog(@"couldn't become first responder");
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    [menu setMenuItems:menuItems];
    
    CGPoint location = [sender locationInView:[sender view]];
    
    [menu setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[sender view]];
    
    [menu setMenuVisible:YES animated:YES];
}

// core data

// same completion handler for open and create may not be appropriate.
// maybe use different ones, or add method with two handlers?
+ (UIManagedDocument *) createOrOpenManagedDocumentWithUrl:(NSURL *)url CompletionHandler:(void(^)(BOOL success)) completionHandler
{
    UIManagedDocument * document = [[UIManagedDocument alloc] initWithFileURL:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        // already exists
        [document openWithCompletionHandler:completionHandler];
    }
    else
    {
        // does not exist, create
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:completionHandler];
    }
    return document;
}

+ (UIManagedDocument *) OpenManagedDocumentWithUrl:(NSURL *)url CompletionHandler:(void(^)(BOOL success)) completionHandler
{
    UIManagedDocument * document = [[UIManagedDocument alloc] initWithFileURL:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        // already exists
        [document openWithCompletionHandler:completionHandler];
    }
    else
    {
        // does not exist, return nil
        document = nil;
        completionHandler(NO);
    }
    return document;
}

+ (UIManagedDocument *) CreateManagedDocumentWithUrl:(NSURL *)url CompletionHandler:(void(^)(BOOL success)) completionHandler
{
    UIManagedDocument * document = [[UIManagedDocument alloc] initWithFileURL:url];
    [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:completionHandler];
    return document;
}



// these are collage specific, either move them or change them to be more generic
// probably don't need them any more now, as using core data

+ (void) removeArchiveFileAndImages
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString * workingFolder = [self getCollageFolderPath];
    
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:workingFolder error:&error];
    if (error == nil)
    {
        for (NSString *path in directoryContents)
        {
            NSString * fullPath = [self createPathForFilename:path];
            BOOL removeSuccess = [fileManager removeItemAtPath:fullPath error:&error];
            if (!removeSuccess)
            {
                NSLog(@"Could not delete file: %@", [error localizedDescription]);
            }
        }
    }
    else
    {
        NSLog(@"could not get contents for working folder: %@", [error localizedDescription]);
    }
}

+ (MPVCollage *) getArchivedCollage
{
    NSString * workingFolder = [MPVUtilities getCollageFolderPath];
    NSString *filePath = [workingFolder stringByAppendingPathComponent:MPVkCollageArchiveFilename];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (void) archiveCollage: (MPVCollage *) collage
{
    NSString * workingFolder = [MPVUtilities getCollageFolderPath];
    NSString *filePath = [workingFolder stringByAppendingPathComponent:MPVkCollageArchiveFilename];
    if (collage != nil)
        [NSKeyedArchiver archiveRootObject:collage toFile:filePath];
}

+ (void) saveCollageToCameraRoll:(UIImage *) image
{
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Collage Saved"
                                                      message:@"Collage saved to Camera Roll"
                                                     delegate: nil
                                            cancelButtonTitle:@"ok"
                                            otherButtonTitles:nil];
    [message show];
}

// internal, not public

+ (NSString *) getCollageFolderPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString * workingFolderPath = [documentsPath stringByAppendingPathComponent:@"working"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL success = [fileManager createDirectoryAtPath:workingFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    // should put up alert or something on failure
    if (! success)
        workingFolderPath = nil;
    
    
    return workingFolderPath;
}

+ (void) saveExportedImage: (UIImage *) exportedImage
{
    UIImageWriteToSavedPhotosAlbum(exportedImage, nil, nil, nil);
}

+ (NSString *) getThumbnailName: (NSString *) imageName
{
    NSString * name = [[NSString alloc] initWithFormat:@"%@_thumb", imageName];
    return name;
}

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaleBy:(float)scale
{
    CGSize targetSize = CGSizeMake(sourceImage.size.width * scale, sourceImage.size.height * scale);
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaledWidth = targetSize.width;
    CGFloat scaledHeight = targetSize.height;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        // make image center aligned
        // Check if need this! Probably not, using same ratios
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    return newImage ;
}

@end
