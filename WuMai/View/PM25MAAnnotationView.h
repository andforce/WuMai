//
//  PM25MAAnnotationView.h
//  WuMai
//
//  Created by 迪远 王 on 2018/4/1.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface PM25MAAnnotationView : MAAnnotationView

- (void)showAqi:(NSString *)aqiLevel zoom:(int)zoomLevel;

- (void)refreshImage:(int)zoomLevel;

@end
