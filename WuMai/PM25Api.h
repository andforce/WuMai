//
//  PM25Api.h
//  WuMai
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <Foundation/Foundation.h>

@class Monitors;

typedef void (^Handler)(NSArray<Monitors *> *monitors);

@interface PM25Api : NSObject

- (void)fetchMonitors:(float)zoomLevel leftLat:(double)llat leftLon:(double)llon rightLat:(double)rlat rightLon:(double)rlon handler:(Handler)handler;

@end
