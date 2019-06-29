//
//  OpenCVWrapper.h
//  OpenCVTest
//
//  Created by Timothy Poulsen on 11/27/18.
//  Copyright © 2018 Timothy Poulsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSString *)openCVVersionString;
+ (NSString *)matchLeopard:(UIImage *)image;
+ (NSArray *)getListOfIDs;
+ (NSString *)matchSpecificLeopardWithID:(UIImage *)image idPath:(NSString *) imageString;

@end

NS_ASSUME_NONNULL_END
