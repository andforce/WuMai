//
//  ViewController.m
//  PM25Map
//
//  Created by 迪远 王 on 2018/4/1.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import "ViewController.h"

#import <MAMapKit/MAMapKit.h>
#import "DataModels.h"
#import "PM25MAPointAnnotation.h"
#import "PM25MAAnnotationView.h"
#import "PM25Api.h"


@interface ViewController ()<MAMapViewDelegate>{
    MAMapView *_mapView;

    PM25Api *_pm25Api;

    NSMutableArray<Monitors *> *_datas;

    int _lastZoomLevel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pm25Api = [[PM25Api alloc] init];

    _datas = [NSMutableArray array];

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

- (void) fetchMonitors:(MAMapView *) mapView{
    CGRect frame = mapView.frame;
    CGPoint leftBottom = CGPointMake(frame.origin.x, frame.origin.y + frame.size.height);
    CGPoint rightTop = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);

    CLLocationCoordinate2D left = [mapView convertPoint:leftBottom toCoordinateFromView:mapView];
    CLLocationCoordinate2D right = [mapView convertPoint:rightTop toCoordinateFromView:mapView];

    [_pm25Api fetchMonitors:_mapView.zoomLevel leftLat:left.latitude leftLon:left.longitude rightLat:right.latitude rightLon:right.longitude handler:^(NSArray<Monitors *> *monitors) {
        NSMutableArray<Monitors*> *toAdd = [NSMutableArray array];
        for(Monitors * m in monitors){
            if ([_datas containsObject:m]){

            } else{
                [toAdd addObject:m];
            }
        }

        NSArray<PM25MAPointAnnotation*> * toAddAnns = [self monitorsToAnnotations:toAdd zoom:(int)mapView.zoomLevel];

        [mapView addAnnotations:toAddAnns];

        NSLog(@"LIFE_CYCLE:fetchMonitors:%d, toAdd:%d, DATA:%d",monitors.count, toAdd.count, _datas.count);

        [_datas addObjectsFromArray:toAdd];
    }];
}

    
#pragma 移动

-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    NSLog(@"LIFE_CYCLE:mapDidMoveByUser-wasUserAction:%@", wasUserAction ? @"YES":@"NO");
    if (wasUserAction || _datas.count == 0){
        [self fetchMonitors:mapView];
    }
}

- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    _lastZoomLevel = (int)mapView.zoomLevel;

    NSLog(@"LIFE_CYCLE:mapWillZoomByUser-wasUserAction:%@, ZoomLevel:%d", wasUserAction ? @"YES":@"NO", _lastZoomLevel);
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {

    int nowZoomLevel = (int)mapView.zoomLevel;

    NSLog(@"LIFE_CYCLE:mapDidZoomByUser-wasUserAction:%@, ZoomLevel:%d", wasUserAction ? @"YES":@"NO", nowZoomLevel);

    if (_lastZoomLevel != nowZoomLevel){

        NSArray * annotations = mapView.annotations;

        for (id <MAAnnotation> annotation in annotations) {
            if ([annotation isKindOfClass:[PM25MAPointAnnotation class]]){
                PM25MAAnnotationView * annotationView = (PM25MAAnnotationView *)[mapView viewForAnnotation:annotation];
                [annotationView refreshImage:(int)mapView.zoomLevel];
            }
        }

        if (wasUserAction || _datas.count == 0){
            [self fetchMonitors:mapView];
        }
    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"LIFE_CYCLE:didAddAnnotationViews");
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

















