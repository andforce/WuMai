//
//  PM25Api.m
//  PM25Map
//
//  Created by 迪远 王 on 2018/4/3.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import "PM25Api.h"
#import "Monitors.h"

#import <MAMapKit/MAMapKit.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "DataModels.h"
#import "PM25MAPointAnnotation.h"
#import "PM25MAAnnotationView.h"

@implementation PM25Api {
    AFHTTPSessionManager *_browser;
}

- (instancetype)init {
    if (self = [super init]) {
        _browser = [AFHTTPSessionManager manager];
        _browser.responseSerializer = [AFHTTPResponseSerializer serializer];
        _browser.responseSerializer.acceptableContentTypes = [_browser.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [_browser.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36" forHTTPHeaderField:@"User-Agent"];

    }

    return self;
}


- (void)fetchMonitors:(float)zoomLevel leftLat:(double)llat leftLon:(double)llon rightLat:(double)rlat rightLon:(double)rlon handler:(Handler)handler {
    NSDate *date = [NSDate date];
    long timeStamp = (NSInteger) [date timeIntervalSince1970];
    NSString *url = [NSString stringWithFormat:@"https://sp0.baidu.com/5LMDcjW6BwF3otqbppnN2DJv/weather.pae.baidu.com/weather/data/Monitorlist?z=%d&lb=%f,%f&rt=%f,%f&_=%ld", (int) zoomLevel, llon, llat, rlon, rlat, timeStamp];

    [_browser GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        NSString *jsonDataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSData *data = [jsonDataString dataUsingEncoding:NSUTF8StringEncoding];

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions) kNilOptions error:nil];

        PM25Module *module = [[PM25Module alloc] initWithDictionary:dictionary];

        NSArray<Monitors *> *monitors = [[module data] monitors];

        NSLog(@"获取到的检测点数量： %ld", (long) monitors.count);

        handler(monitors);

    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        handler(nil);
    }];
}


@end
