//
//  PM25MAPointAnnotation.h
//  WuMai
//
//  Created by 迪远 王 on 2018/4/1.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "DataModels.h"

@interface PM25MAPointAnnotation : MAPointAnnotation


// 检测点
@property (nonatomic, strong) Monitors* monitors;

@property (nonatomic) int zoomLevel;

@end
