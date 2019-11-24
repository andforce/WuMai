//
//  WuMaiImageHelper.h
//  WuMai
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface WuMaiImageHelper : NSObject

+ (WuMaiImageHelper *)shareInstance;

- (UIImage *)image:(int)zoomLevel with:(int)aqiLevel;

@end
