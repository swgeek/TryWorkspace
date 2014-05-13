//
//  MPVCollageModel+Convenience.h
//  MPVCollageElementModel
//
//  Created by Manoj Patel on 12/30/13.
//  Copyright (c) 2013 Manoj Patel. All rights reserved.
//

// is it better to have category or wrapper? Not sure.
// for now use a category, but may switch to wrapper at some point.
#import "MPVCollageModel.h"

@class MPVCollageElementModel;

@interface MPVCollageModel (Convenience)

@property (readonly) NSInteger elementCount;
@property (weak, nonatomic) UIColor * backgroundColor;
@property (weak, nonatomic) UIColor * globalBorderColor;

extern NSString * collageClassName; //@"MPVCollageModel"

// returns index
- (NSInteger) addElementModelwithX:(float) x
                           Y:(float)y
                       width:(float) width
                      height:(float)height
                       color:(UIColor *)color
                 borderWidth:(float)borderWidth
                 borderColor:(UIColor *)borderColor
                  andOpacity:(float)opacity;

- (MPVCollageElementModel *) elementAtIndex:(NSInteger)index;

@end
