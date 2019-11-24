//
//  PM25ImageHelper.h
//  WuMai
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface PM25ImageHelper : NSObject

+ (PM25ImageHelper *)shareInstance;

- (UIImage *)image:(int)zoomLevel with:(int)aqiLevel;

@end
