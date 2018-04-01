//
//  PM25MAAnnotationView.m
//  PM25Map
//
//  Created by 迪远 王 on 2018/4/1.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import "PM25MAAnnotationView.h"

@implementation PM25MAAnnotationView{
    UILabel * _label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]){
        _label = [[UILabel alloc] initWithFrame:self.frame];
        _label.text = @"500";
        //_label.backgroundColor = UIColor.blackColor;
        _label.textColor = UIColor.whiteColor;
        UIFont *font = [UIFont systemFontOfSize:12];
        _label.font = font;
        _label.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_label];
    }

    return self;

}


- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = CGRectMake(0, 0 - 2, self.bounds.size.width, self.bounds.size.height);
}

- (void)showAqiBig:(NSString *)level {

    int levelInt = [level intValue];

    self.image = [self rectImage:levelInt];

    _label.text = level;
}

- (void)showAqiSmall:(NSString *)level {


    int levelInt = [level intValue];

    self.image = [self pointImage:levelInt];

    _label.text = @"";
}


- (UIImage *) pointImage:(int)aqiLevel {
    UIImage *result = nil;

    if (aqiLevel >= 0 && aqiLevel <= 50){
        result = [UIImage imageNamed:@"aqi_map_point_level_1_8x8_@2x.png"];
    } else if (aqiLevel >= 51 && aqiLevel <= 100){
        result = [UIImage imageNamed:@"aqi_map_point_level_2_8x8_@2x.png"];
    }else if (aqiLevel >= 101 && aqiLevel <= 150){
        result = [UIImage imageNamed:@"aqi_map_point_level_3_8x8_@2x.png"];
    }else if (aqiLevel >= 151 && aqiLevel <= 200){
        result = [UIImage imageNamed:@"aqi_map_point_level_4_8x8_@2x.png"];
    }else if (aqiLevel >= 201 && aqiLevel <= 300){
        result = [UIImage imageNamed:@"aqi_map_point_level_5_8x8_@2x.png"];
    }else if (aqiLevel > 300){
        result = [UIImage imageNamed:@"aqi_map_point_level_6_8x8_@2x.png"];
    }
    return result;
}

- (UIImage *) rectImage:(int)aqiLevel {
    UIImage *result = nil;

    if (aqiLevel >= 0 && aqiLevel <= 50){
        result = [UIImage imageNamed:@"aqi_map_level_1_30x27_@2x.png"];
    } else if (aqiLevel >= 51 && aqiLevel <= 100){
        result = [UIImage imageNamed:@"aqi_map_level_2_30x27_@2x.png"];
    }else if (aqiLevel >= 101 && aqiLevel <= 150){
        result = [UIImage imageNamed:@"aqi_map_level_3_30x27_@2x.png"];
    }else if (aqiLevel >= 151 && aqiLevel <= 200){
        result = [UIImage imageNamed:@"aqi_map_level_4_30x27_@2x.png"];
    }else if (aqiLevel >= 201 && aqiLevel <= 300){
        result = [UIImage imageNamed:@"aqi_map_level_5_30x27_@2x.png"];
    }else if (aqiLevel > 300){
        result = [UIImage imageNamed:@"aqi_map_level_6_30x27_@2x.png"];
    }

    return result;
}

- (void)showAqi:(NSString *)aqiLevel zoom:(int)zoomLevel {

    if (zoomLevel >= 7){
        [self showAqiBig:aqiLevel];
    } else {
        [self showAqiSmall:aqiLevel];
    }

}


@end
