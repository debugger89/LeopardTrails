//
//  OpenCVWrapper.m
//  OpenCVTest
//
//  Created by Timothy Poulsen on 11/27/18.
//  Copyright © 2018 Timothy Poulsen. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"
#import <opencv2/imgcodecs/ios.h>
#import <UIKit/UIKit.h>
#import <opencv2/imgproc.hpp>
#include <opencv2/features2d/features2d.hpp>

#include "opencv2/features2d.hpp"
#include "opencv2/xfeatures2d/nonfree.hpp"
#include <opencv2/xfeatures2d.hpp>


@implementation OpenCVWrapper

//typedef NS_ENUM(NSUInteger, )
//COLOR_BGR2GRAY     = 6, //!< convert between RGB/BGR and grayscale, @ref color_convert_rgb_gray "color conversions"
//COLOR_RGB2GRAY     = 7,

NSUInteger MIN_MATCH_COUNT = 10;


+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

+ (NSArray *)getListOfIDs {
    
    NSString *directory = [NSString stringWithFormat:@"IdImages"];
    NSArray *ids = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:directory];
    NSLog(@"%@", ids);
    
    return ids;
}
    
+ (NSArray *)getListOfIDs: (NSString* )nationalParkName{
    
    NSString *directory = [NSString stringWithFormat:[@"IdImages/" stringByAppendingString:nationalParkName]];
    NSArray *ids = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:directory];
    NSLog(@"%@", ids);
    
    return ids;
}


+ (NSString *)testSIFT {
    
    cv::Ptr<cv::Feature2D> sift = cv::xfeatures2d::SIFT::create();

   return @"grayscale";
}
    
+ (NSString *)matchSpecificLeopardWithID:(UIImage *)image idPath:(NSString *) imageString {
    
    @autoreleasepool {
        
        
        NSLog(@"Checking ::: %@", imageString);
        UIImage *idImage = [[UIImage alloc] initWithContentsOfFile: imageString];
        
        BOOL matched = [self compareAndMatchImages:idImage target_image:image];
        if(matched) {
            
            NSRange lastSlashIndex = [imageString rangeOfString:@"/" options:NSBackwardsSearch];
            NSRange lastDotIndex = [imageString rangeOfString:@"." options:NSBackwardsSearch];
            
            NSString *matchedName = [imageString substringWithRange:NSMakeRange(lastSlashIndex.location + 1 , (lastDotIndex.location - lastSlashIndex.location - 1))];
            
            idImage = nil;
            image = nil;
            return matchedName;
        }else{
            idImage = nil;
            image = nil;
            return nil;
        }
        
    }
}
    
+ (NSString *)matchTest:(NSString *)targetImage idPath:(NSString *) idImage; {
    
    @autoreleasepool {
        
        
        UIImage *targetImageImg = [[UIImage alloc] initWithContentsOfFile: targetImage];
        UIImage *idImageImg = [[UIImage alloc] initWithContentsOfFile: idImage];
        
        BOOL matched = [self compareAndMatchImages:idImageImg target_image:targetImageImg];
        if(matched) {
            
            printf("Matched !!");
            
            return @"matched";
        }else{
            return nil;
        }
        
    }
}

+ (NSString *)matchLeopard:(UIImage *)image {
    
    @autoreleasepool {
        
        NSArray *ids = [self getListOfIDs];
        
        for (id imageString in ids) {
            NSLog(@"Checking ::: %@", imageString);
            UIImage *idImage = [[UIImage alloc] initWithContentsOfFile: imageString];
            
            BOOL matched = [self compareAndMatchImages:idImage target_image:image];
            if(matched) {
                return imageString;
            }
        }
        return @"Not Matched With Current Database!";
    }
}
    
    
    

+ (BOOL)compareAndMatchImages:(UIImage *)id_image target_image:(UIImage *)target_image {
    cv::Mat id_mat, target_mat;
    UIImageToMat(id_image, id_mat);
    UIImageToMat(target_image, target_mat);
    
    float sensitivity = [[[NSUserDefaults standardUserDefaults] stringForKey:@"SENSITIVITY"] floatValue];
    
    //cv::resize(id_mat, id_mat, cv::Size(), 0.30, 0.30);
    cv::resize(target_mat, target_mat, cv::Size(), sensitivity, sensitivity);
    
    cv::Ptr<cv::Feature2D> f2d = cv::xfeatures2d::SiftFeatureDetector::create();
    
    std::vector<cv::KeyPoint> kp1, kp2;
    cv::Mat des1, des2;
    f2d->detectAndCompute(id_mat, cv::noArray(), kp1, des1);
    f2d->detectAndCompute(target_mat, cv::noArray(), kp2, des2);
    
    //cv::FlannBasedMatcher matcher = new cv::FlannBasedMatcher();
    cv::Ptr<cv::DescriptorMatcher> matcher;
    matcher = new cv::BFMatcher();
    
    //cv::Ptr<cv::DescriptorMatcher> matcher = cv::DescriptorMatcher::create(cv::DescriptorMatcher::FLANNBASED);
    std::vector< std::vector<cv::DMatch> > knn_matches;
    matcher -> knnMatch( des1, des2, knn_matches, 2 );
    
    //-- Filter matches using the Lowe's ratio test
    const float ratio_thresh = 0.7f;
    std::vector<cv::DMatch> good_matches;
    for (size_t i = 0; i < knn_matches.size(); i++)
    {
        if (knn_matches[i][0].distance < ratio_thresh * knn_matches[i][1].distance)
        {
            good_matches.push_back(knn_matches[i][0]);
        }
    }
    
    if(good_matches.size() > MIN_MATCH_COUNT){
        
        return true;
    }else{

        return false;
    }

}

+ (UIImage *)detectEdgesInRGBImage:(UIImage *)image {
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::Mat gray;
    cv::cvtColor(mat, gray, CV_RGB2GRAY);
//    cv::Laplacian(gray, gray, gray.depth());
    cv::Sobel(gray, gray, gray.depth(), 1, 0);
    UIImage *grayscale = MatToUIImage(gray);
    return grayscale;
}

+ (UIImage *)blur:(UIImage *)image radius:(double)radius {
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::GaussianBlur(mat, mat, cv::Size(NULL, NULL), radius);
    UIImage *blurredImage = MatToUIImage(mat);
    return blurredImage;
}

+ (UIImage *)getChannel:(UIImage *)image channel:(NSString *)channel {
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::Mat baseImage = cv::Mat::zeros(mat.size(), CV_8UC3);
    // UIImage is RGB, so our default here is blue
    int ch = 2;
    if ([channel isEqual: @"r"] || [channel isEqual: @"R"]) {
        ch = 0;
    } else if ([channel isEqual: @"g"] || [channel isEqual: @"G"]) {
        ch = 1;
    }
    int from_to[] = { ch,ch };
    cv::mixChannels(&mat, 1, &baseImage, 1, from_to, 1);
    UIImage *retImage = MatToUIImage(baseImage);
    return retImage;
}

@end
