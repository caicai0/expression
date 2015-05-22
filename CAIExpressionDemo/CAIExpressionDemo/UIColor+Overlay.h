//
//  UIColor+Overlay.h
//  CAIUtils
//
//  Created by liyufeng on 15/5/14.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Overlay)

//两个颜色的中间色 一种渐变算法
//color = startColor*percent+endColor*(1-percent);
//注意只能计算rgba 的颜色  不能计算灰度
+ (UIColor *)colorBetweenStartColor:(UIColor *)startColor endColor:(UIColor *)endColor percent:(float)percent;

@end
