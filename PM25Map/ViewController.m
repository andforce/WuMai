//
//  ViewController.m
//  PM25Map
//
//  Created by 迪远 王 on 2018/4/1.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import "ViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "DataModels.h"
#import "PM25MAPointAnnotation.h"
#import "PM25MAAnnotationView.h"


@interface ViewController ()<MAMapViewDelegate>{
    MAMapView *_mapView;
    AFHTTPSessionManager *_browser;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _browser = [AFHTTPSessionManager manager];
    _browser.responseSerializer = [AFHTTPResponseSerializer serializer];
    _browser.responseSerializer.acceptableContentTypes = [_browser.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [_browser.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    
    
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];

    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.rotateEnabled = NO;
    _mapView.delegate = self;
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
#pragma 移动
-(void)mapViewDidFinishLoadingMap:(MAMapView *)mapView{
    NSLog(@"LIFE_CYCLE:mapViewDidFinishLoadingMap");
}

    
- (void)mapViewRegionChanged:(MAMapView *)mapView{
    //NSLog(@"LIFE_CYCLE:mapViewRegionChanged");
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {

    NSLog(@"ZOOM-------------------------");

    NSArray * currentAnnotations = mapView.annotations;
    [mapView removeAnnotations:currentAnnotations];
}
    
-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{


    NSLog(@"REG Change-------------------------");

    //NSLog(@"LIFE_CYCLE:regionDidChangeAnimated");

//    MAMapRect rect = mapView.visibleMapRect;

    NSArray * currentAnnotations = mapView.annotations;
//    [mapView removeAnnotations:currentAnnotations];

    NSMutableArray *toAdd = [NSMutableArray array];

    NSLog(@"zoom level %f", mapView.zoomLevel);

    CGRect frame = mapView.frame;
    CGPoint leftBottom = CGPointMake(frame.origin.x, frame.origin.y + frame.size.height);
    CGPoint rightTop = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    
    CLLocationCoordinate2D left = [mapView convertPoint:leftBottom toCoordinateFromView:mapView];
    CLLocationCoordinate2D right = [mapView convertPoint:rightTop toCoordinateFromView:mapView];

    int zoomLevel = (int)mapView.zoomLevel;


    NSDate *date = [NSDate date];
    long timeStamp = (NSInteger) [date timeIntervalSince1970];
    
    NSString * url = [NSString stringWithFormat:@"https://sp0.baidu.com/5LMDcjW6BwF3otqbppnN2DJv/weather.pae.baidu.com/weather/data/Monitorlist?z=%d&lb=%f,%f&rt=%f,%f&_=%ld", zoomLevel,left.longitude, left.latitude, right.longitude, right.latitude, timeStamp];
    
    [_browser GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *a= string;
        
        NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions) kNilOptions error:nil];

        PM25Module * module = [[PM25Module alloc] initWithDictionary:dictionary];
        
        NSArray<Monitors*> *monitors = [[module data] monitors];
        
        NSLog(@"获取到的检测点数量： %ld", (long) monitors.count);

        NSMutableArray * newAnnotations = [self monitorsToAnnotations:monitors zoom:zoomLevel];

//        NSArray * cas = mapView.annotations;
//        [mapView removeAnnotations:cas];

        NSMutableArray *oldToAdd = [NSMutableArray array];

//        NSMutableArray *removeAnnotations = [NSMutableArray array];

        for (id <MAAnnotation> currentAnnotation in currentAnnotations) {
            if (![newAnnotations containsObject: currentAnnotation]){
                //[mapView removeAnnotation:currentAnnotation];
//                [removeAnnotations addObject:currentAnnotation];
                [oldToAdd addObject:currentAnnotation];
                NSLog(@"新数据中存在，删除=======================");
            } else {
//                if ([currentAnnotation isKindOfClass:[PM25MAPointAnnotation class]]){
//                    PM25MAPointAnnotation *annotation = (PM25MAPointAnnotation *)currentAnnotation;
//                    if ((zoomLevel >= 8 && annotation.zoomLevel < 8) || (zoomLevel < 8 && annotation.zoomLevel >= 8)){
//                        [refreshAnnotations addObject:[self monitorToAnnotation:annotation.monitors zoom:zoomLevel]];
//                        //[mapView removeAnnotation:currentAnnotation];
//                        [removeAnnotations addObject:currentAnnotation];
//                        NSLog(@"由于ZoomLevel变化，因此需要更新OLD:%d NEW:%d", zoomLevel, annotation.zoomLevel);
//                    }
//                } else{
//
//                    NSLog(@"这是一条全新的Annition《《《《《《《《《《《《《《《《《《");
//                }
            }
        }

//        [mapView removeAnnotations:removeAnnotations];
        [mapView addAnnotations:newAnnotations];
        [mapView addAnnotations:oldToAdd];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    }];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[PM25MAPointAnnotation class]]) {

        PM25MAPointAnnotation * pm25MAPointAnnotation = (PM25MAPointAnnotation *) annotation;
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        PM25MAAnnotationView *annotationView = (PM25MAAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[PM25MAAnnotationView alloc] initWithAnnotation:pm25MAPointAnnotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout = YES;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO

        Monitors * monitor = pm25MAPointAnnotation.monitors;
        Pm25 * pm25 = monitor.pm25;
        
        int zoomLevel = (int)mapView.zoomLevel;
        NSLog(@"zoom Level %d", zoomLevel);
        [annotationView showAqi:pm25.val zoom:zoomLevel];
        return annotationView;
    }

    return nil;
}
    
-(NSMutableArray<PM25MAPointAnnotation*> *)monitorsToAnnotations:(NSArray *)monitorsArr zoom:(int)zoomLevel{
    NSMutableArray *result = [NSMutableArray array];

    for (Monitors * monitors in monitorsArr){
        PM25MAPointAnnotation *annotation = [[PM25MAPointAnnotation alloc] init];
        double lat = [monitors.pos.lat doubleValue];
        double lon = [monitors.pos.lng doubleValue];
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
        annotation.monitors = monitors;
        annotation.zoomLevel = zoomLevel;

        [result addObject:annotation];
    }
    return result;
}

-(PM25MAPointAnnotation *)monitorToAnnotation:(Monitors *) monitors zoom:(int)zoomLevel{
    PM25MAPointAnnotation *annotation = [[PM25MAPointAnnotation alloc] init];
    double lat = [monitors.pos.lat doubleValue];
    double lon = [monitors.pos.lng doubleValue];
    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
    annotation.monitors = monitors;
    annotation.zoomLevel = zoomLevel;
    return annotation;
}
    
@end

















