//
//  WuMaiLevelApi.h
//  WuMai
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Monitors;

@interface WuMaiLevelApi : NSObject

- (void)findAirMonitors:(float)zoomLevel leftLocation:(CLLocationCoordinate2D)left rightLocation:(CLLocationCoordinate2D)right handler:(void (^)(NSArray<Monitors *> *))handler;

@end
