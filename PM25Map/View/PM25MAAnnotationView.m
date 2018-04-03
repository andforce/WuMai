//
//  PM25MAAnnotationView.m
//  PM25Map
//
//  Created by 迪远 王 on 2018/4/1.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import "PM25MAAnnotationView.h"
#import "PM25ImageHelper.h"

@implementation PM25MAAnnotationView{
    UILabel * _label;
    int _aqiLevel;
    NSString * _aqiLevelStr;
    int _zoomLevel;
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

- (void)showAqi:(NSString *)aqiLevel zoom:(int)zoomLevel {

    _aqiLevelStr = aqiLevel;
    _aqiLevel = [aqiLevel intValue];
    _zoomLevel = zoomLevel;

    self.image = [[PM25ImageHelper shareInstance] image:zoomLevel with:_aqiLevel];

    if (zoomLevel > 7){
        _label.text = aqiLevel;
    } else {
        _label.text = @"";
    }

}

- (void)refreshImage:(int)zoomLevel {
    if (zoomLevel == _zoomLevel){
        return;
    }
    self.image = [[PM25ImageHelper shareInstance] image:zoomLevel with:_aqiLevel];

    if (zoomLevel > 7){
        _label.text = _aqiLevelStr;
    } else {
        _label.text = @"";
    }
}


@end
