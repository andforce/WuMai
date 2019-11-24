//
//  WuMainPointAnnotation.h
//  WuMai
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "DataModels.h"

@interface WuMainPointAnnotation : MAPointAnnotation


// 检测点
@property(nonatomic, strong) Monitors *monitors;

@property(nonatomic) int zoomLevel;

@end
