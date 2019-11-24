//
//  ViewController.m
//  WuMai
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import "ViewController.h"

#import <MAMapKit/MAMapKit.h>
#import "DataModels.h"
#import "WuMainPointAnnotation.h"
#import "WuMaiAnnotationView.h"
#import "PM25Api.h"

@interface ViewController () <MAMapViewDelegate> {
    MAMapView *_mapView;

    PM25Api *_pm25Api;

    NSMutableArray<Monitors *> *_datas;

    int _lastZoomLevel;

    MAMapPoint point1;
    MAMapPoint point2;

    IBOutlet UIButton *locationBtn;
}

@end

@implementation ViewController

- (IBAction)changeUserTrackMode:(id)sender {
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _pm25Api = [[PM25Api alloc] init];

    _datas = [NSMutableArray array];

    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.logoCenter = CGPointMake(self.view.bounds.size.width / 2, _mapView.logoCenter.y);

    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.rotateEnabled = NO;
    _mapView.delegate = self;

    ///把地图添加至view
    [self.view addSubview:_mapView];

    [self.view sendSubviewToBack:_mapView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMonitors:(MAMapView *)mapView {

    NSLog(@"LIFE_CYCLE:fetchMonitors: 开始获取数据");

    CGRect frame = mapView.frame;
    CGPoint leftBottom = CGPointMake(frame.origin.x, frame.origin.y + frame.size.height);
    CGPoint rightTop = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);

    CLLocationCoordinate2D left = [mapView convertPoint:leftBottom toCoordinateFromView:mapView];
    CLLocationCoordinate2D right = [mapView convertPoint:rightTop toCoordinateFromView:mapView];

    [_pm25Api fetchMonitors:_mapView.zoomLevel leftLat:left.latitude leftLon:left.longitude rightLat:right.latitude rightLon:right.longitude handler:^(NSArray<Monitors *> *monitors) {
        NSMutableArray<Monitors *> *toAdd = [NSMutableArray array];
        for (Monitors *m in monitors) {
            if ([_datas containsObject:m]) {

            } else {
                [toAdd addObject:m];
            }
        }

        NSArray<WuMainPointAnnotation *> *toAddAnns = [self monitorsToAnnotations:toAdd zoom:(int) mapView.zoomLevel];

        [mapView addAnnotations:toAddAnns];

        NSLog(@"LIFE_CYCLE:fetchMonitors:%d, toAdd:%d, DATA:%d", monitors.count, toAdd.count, _datas.count);

        [_datas addObjectsFromArray:toAdd];
    }];
}


#pragma 移动

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {

    if (wasUserAction){
        point1 = MAMapPointForCoordinate(mapView.centerCoordinate);
    }
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {

    NSLog(@"LIFE_CYCLE:mapDidMoveByUser-wasUserAction:%@", wasUserAction ? @"YES" : @"NO");

    if (wasUserAction){
        point2 = MAMapPointForCoordinate(mapView.centerCoordinate);
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1, point2);
        NSLog(@"LIFE_CYCLE:mapDidMoveByUser-移动距离:%f", distance);
        if (distance > 50 * 1000){
            [self fetchMonitors:mapView];
        }
    } else if (_datas.count == 0) {
        [self fetchMonitors:mapView];
    }
}

- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    _lastZoomLevel = (int) mapView.zoomLevel;

    NSLog(@"LIFE_CYCLE:mapWillZoomByUser-wasUserAction:%@, ZoomLevel:%d", wasUserAction ? @"YES" : @"NO", _lastZoomLevel);
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {

    int nowZoomLevel = (int) mapView.zoomLevel;

    NSLog(@"LIFE_CYCLE:mapDidZoomByUser-wasUserAction:%@, ZoomLevel:%d", wasUserAction ? @"YES" : @"NO", nowZoomLevel);

    if (_lastZoomLevel != nowZoomLevel) {

        NSArray *annotations = mapView.annotations;

        for (id <MAAnnotation> annotation in annotations) {
            if ([annotation isKindOfClass:[WuMainPointAnnotation class]]) {
                WuMaiAnnotationView *annotationView = (WuMaiAnnotationView *) [mapView viewForAnnotation:annotation];
                [annotationView refreshImage:(int) mapView.zoomLevel];
            }
        }

        if (wasUserAction || _datas.count == 0) {
            [self fetchMonitors:mapView];
        }
    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"LIFE_CYCLE:didAddAnnotationViews");
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {

    if ([annotation isKindOfClass:[WuMainPointAnnotation class]]) {

        WuMainPointAnnotation *pm25MAPointAnnotation = (WuMainPointAnnotation *) annotation;
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        WuMaiAnnotationView *annotationView = (WuMaiAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[WuMaiAnnotationView alloc] initWithAnnotation:pm25MAPointAnnotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout = YES;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO

        Monitors *monitor = pm25MAPointAnnotation.monitors;
        Pm25 *pm25 = monitor.pm25;

        int zoomLevel = (int) mapView.zoomLevel;

        [annotationView showAqi:pm25.val zoom:zoomLevel];
        return annotationView;
    }

    return nil;
}

- (NSMutableArray<WuMainPointAnnotation *> *)monitorsToAnnotations:(NSArray *)monitorsArr zoom:(int)zoomLevel {
    NSMutableArray *result = [NSMutableArray array];

    for (Monitors *monitors in monitorsArr) {
        WuMainPointAnnotation *annotation = [[WuMainPointAnnotation alloc] init];
        double lat = [monitors.pos.lat doubleValue];
        double lon = [monitors.pos.lng doubleValue];
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
        annotation.monitors = monitors;
        annotation.zoomLevel = zoomLevel;

        [result addObject:annotation];
    }
    return result;
}

- (WuMainPointAnnotation *)monitorToAnnotation:(Monitors *)monitors zoom:(int)zoomLevel {
    WuMainPointAnnotation *annotation = [[WuMainPointAnnotation alloc] init];
    double lat = [monitors.pos.lat doubleValue];
    double lon = [monitors.pos.lng doubleValue];
    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
    annotation.monitors = monitors;
    annotation.zoomLevel = zoomLevel;
    return annotation;
}

@end
