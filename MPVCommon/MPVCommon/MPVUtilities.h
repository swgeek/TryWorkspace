//
//  MPVUtilities.h
//  MPVCommon
//
//  Created by Manoj Patel on 5/19/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

// collection of code that comes up a lot in projects. some are simple, but putting them here
// saves me having to remember how to do it each time

#import <Foundation/Foundation.h>

@class MPVCollage;

@interface MPVUtilities : NSObject

// format conversion, find out if some of these exist in apple libraries

+ (UIColor *) colorFromHexString:(NSString *)colorString;

+ (NSData *) DataFromColor:(UIColor *) color;

+ (UIColor *) ColorFromData:(NSData *) colorData;

// image and view stuff

+ (void) setScaleAndCenterTransforms: (UIView *) childView toRect:(CGRect) parentRect withMargin:(float)margin;

+ (float) getScaleToFitSize:(CGSize) child intoSize:(CGSize)parent withMargin:(float)margin;

+ (UIImage *) createThumbnail:(UIImage *)sourceImage withLongEdge:(float)longEdgeLength;

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize withInterpolationQuality:(CGInterpolationQuality)quality;

// file stuff
+ (NSString *)createPathForFilename:(NSString *)filename;

+ (NSString *) saveImage: (UIImage *) image; // save to a file, return generated filename

+ (UIImage *) getImage: (NSString *) fileName;

+ (NSURL *) GetDocumentFileUrl:(NSString *) documentName;

+ (void) removeFile: (NSString *) filename;

// pop up menu
+ (void)showMenu:(UIGestureRecognizer *)sender forOwner:(id)owner withMenuItems:(NSArray *)menuItems;

// core data

+ (UIManagedDocument *) createOrOpenManagedDocumentWithUrl:(NSURL *)url CompletionHandler:(void(^)(BOOL success)) completionHandler;

+ (UIManagedDocument *) OpenManagedDocumentWithUrl:(NSURL *)url CompletionHandler:(void(^)(BOOL success)) completionHandler;

+ (UIManagedDocument *) CreateManagedDocumentWithUrl:(NSURL *)url CompletionHandler:(void(^)(BOOL success)) completionHandler;

// these are collage specific, either move them or change them to be more generic

+ (void) removeArchiveFileAndImages;

+ (MPVCollage *) getArchivedCollage;

+ (void) archiveCollage: (MPVCollage *) collage;

+ (void) saveCollageToCameraRoll:(UIImage *) image;

@end
