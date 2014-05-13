//
//  MPVCollageModelHelper.m
//  MPVCollageElementModel
//
//  Created by Manoj Patel on 12/31/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVCollageModelHelper.h"
#import "MPVCollageModel+Convenience.h"
#import "MPVCollageElementModel+Convenience.h"
#import "MPVCollage.h"
#import "MPVElement.h"
#import "MPVUtilities.h"

// Add thread stuff so can do all image saving in the background, here or elsewhere...

@interface MPVCollageModelHelper()
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@end

@implementation MPVCollageModelHelper

//- (id) initWithDocumentUrl:(NSURL *) url andCompletionHandler:(void(^)(MPVCollage * collage)) completionHandler
//{
//    self = [super init];
//    
//    if (self)
//    {
//        UIManagedDocument * document = [[UIManagedDocument alloc] initWithFileURL:url];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
//        {
//            // already exists
//            [document openWithCompletionHandler:^(BOOL success) {
//                if (success)
//                {
//                    // don't like using self here as may not be ready, but for now...
//                    MPVCollage * collage = [self getCollageFromDocument:document];
//                    completionHandler(collage);
//                }
//                else
//                {
//                    // TODOTODO: what to do here? Maybe delete bad file first?
//                    NSLog(@"document could not be opened");
//                    completionHandler(nil);
//                }
//            }];
//        }
//        else
//        {
//            // does not exist, create
//            completionHandler(nil);
//        }
//     }
//    return self;
//}




+ (void)getCollageFromDocument:(NSString *)fileName withCompletionHandler:(void (^)(MPVCollage *))completionHandler
{
    NSURL * url = [MPVUtilities GetDocumentFileUrl:fileName];
    UIManagedDocument * document = [[UIManagedDocument alloc] initWithFileURL:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        // already exists
        [document openWithCompletionHandler:^(BOOL success) {
            if (success)
            {
                // don't like using self here as may not be ready, but for now...
                MPVCollage * collage = [self getCollageFromDocument:document];
                completionHandler(collage);
            }
            else
            {
                // TODOTODO: what to do here? Maybe delete bad file first?
                NSLog(@"document could not be opened");
                completionHandler(nil);
            }
        }];
    }
}


// This is not finished, need mechanism to know when finished, but do later
// may not need at all, may do things a different way
- (void) createDocument:(NSURL *)url
{
    UIManagedDocument * document = [[UIManagedDocument alloc] initWithFileURL:url];
    // TODO: what to do if file already exists? Overwrite? update?
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success)
            {
                self.managedObjectContext = document.managedObjectContext;
            }
            else
            {
                NSLog(@"document could not be opened or created");
            }
        }];
    }
    
}

+ (MPVCollage *) getCollageFromDocument:(UIManagedDocument *)document
{
    
    if (document.documentState != UIDocumentStateNormal)
        return nil;
    
    //self.managedObjectContext = document.managedObjectContext;
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:collageClassName];
    fetchRequest.predicate = nil;
    fetchRequest.sortDescriptors = nil;
    NSError * error;
    NSArray * collages = [document.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    MPVCollageModel * model;
    if (collages.count > 0)
        model = collages[0];
    if (error)
        NSLog(@"%@", [error localizedDescription]);
    
    if (! model)
        return nil;
    
    return [[MPVCollage alloc] initWithCollageModel:model];
}


// note, there should be only one collage saved, Figure out how to enforce that...
// e.g. remove existing collages before creating new one.
- (MPVCollageModel *) createNewCollageModelWithWidth:(float) width
                                    height:(float)height
                           backgroundColor:(UIColor *)color
                         globalborderWidth:(float)borderWidth
                         globalborderColor:(UIColor *)borderColor
{
    MPVCollageModel * newCollage = [NSEntityDescription insertNewObjectForEntityForName:collageClassName inManagedObjectContext:self.managedObjectContext];
    
    newCollage.width = width;
    newCollage.height = height;
    newCollage.backgroundColor = color;
    newCollage.globalBorderColor = borderColor;
    newCollage.globalBorderWidth = borderWidth;
    
    return newCollage;
}

- (MPVCollageElementModel *) createNewElementWithX:(float) x
                                     Y:(float)y
                                 width:(float) width
                                height:(float)height
                                 color:(UIColor *)color
                           borderWidth:(float)borderWidth
                           borderColor:(UIColor *)borderColor
                               opacity:(float)opacity
                              andIndex:(int)index
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
    newElement.index = index;
        
    return newElement;
}

- (MPVCollage *) initializeExampleCollage
{
    
    MPVCollageModel * collageModel = [self createNewCollageModelWithWidth:30 height:50 backgroundColor:[UIColor grayColor] globalborderWidth:1.5 globalborderColor:[UIColor blackColor]];

    MPVCollageElementModel * element1 = [self createNewElementWithX:4 Y:4 width:10 height:10 color:[UIColor blueColor]  borderWidth:-1 borderColor:nil  opacity:1 andIndex:0];

    [collageModel addElementsObject:element1];
    
       MPVCollageElementModel * element2 = [self createNewElementWithX:4 Y:16 width:20 height:30 color:[UIColor greenColor] borderWidth:1 borderColor:[UIColor brownColor] opacity:1 andIndex:1];

    [collageModel addElementsObject:element2];
    

        MPVCollageElementModel * element3 = [self createNewElementWithX:10 Y:6 width:8 height:10 color:[UIColor redColor] borderWidth:1.5 borderColor:[UIColor blackColor] opacity:0.5 andIndex:2];
    
    [collageModel addElementsObject:element3];
    
    return [[MPVCollage alloc] initWithCollageModel:collageModel];
}

@end
