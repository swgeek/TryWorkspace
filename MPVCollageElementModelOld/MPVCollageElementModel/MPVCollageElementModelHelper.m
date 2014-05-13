//
//  MPVCollageElementModelHelper.m
//  TryElementModel
//
//  Created by Manoj Patel on 12/19/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

#import "MPVCollageElementModelHelper.h"
#import "CollageElementModel.h"
#import "CollageElementModel+Convenience.h"
#import "MPVUtilities.h"

@interface MPVCollageElementModelHelper()

@property (strong, nonatomic) UIManagedDocument * managedDocument;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@end

@implementation MPVCollageElementModelHelper

- (id) initWithDocumentUrl:(NSURL *) documentURL andCompletionHandler:(void(^)()) completionHandler
{
    self = [super init];
    
    if (self)
    {
        self.managedDocument = [MPVCollageElementModelHelper createOrOpenManagedDocumentWithUrl:documentURL CompletionHandler:^(BOOL success) {
            if (success)
            {
                [self openManagedDocument];
                completionHandler();
            }
            else
            {
                NSLog(@"document could not be opened or created");
            }
        }];
    }
    return self;
}

- (void) openManagedDocument
{
    if (self.managedDocument.documentState != UIDocumentStateNormal)
        return;
    
    self.managedObjectContext = self.managedDocument.managedObjectContext;
    
    [self getElementList];
}

- (void) getElementList
{
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:elementClassName];
    fetchRequest.predicate = nil;
    fetchRequest.sortDescriptors = nil;
    self.elements = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void) addElementModelwithX:(float) x
                            Y:(float)y
                        width:(float) width
                       height:(float)height
                        color:(UIColor *)color
                  borderWidth:(float)borderWidth
                  borderColor:(UIColor *)borderColor
                        image:(UIImage *)image
                   andOpacity:(float)opacity
{
    CollageElementModel * newElement = [NSEntityDescription insertNewObjectForEntityForName:elementClassName inManagedObjectContext:self.managedObjectContext];
    
    newElement.x = x;
    newElement.y = y;
    newElement.width = width;
    newElement.height = height;
    newElement.color = color;
    newElement.borderWidth = borderWidth;
    newElement.borderColor = borderColor;
    newElement.opacity = opacity;

    if (image)
        newElement.image = image;
   
    // refresh elements so new element shows up
    [self getElementList];
}

-(void) save:(NSURL *)url
{
    [self.managedObjectContext save:nil];
    [self.managedDocument saveToURL:url forSaveOperation:UIDocumentSaveForOverwriting
                  completionHandler:^(BOOL success) {
                      if(success) NSLog(@"saved"); else NSLog(@"failure saving");
    }];
}

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


@end
