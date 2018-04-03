//
//  PM25ImageHelper.h
//  PM25Map
//
//  Created by 迪远 王 on 2018/4/3.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface PM25ImageHelper : NSObject

+ (PM25ImageHelper *) shareInstance;

- (UIImage *)image:(int)zoomLevel with:(int)aqiLevel;

@end
