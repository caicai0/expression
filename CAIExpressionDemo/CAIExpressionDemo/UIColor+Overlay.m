//
//  UIColor+Overlay.m
//  CAIUtils
//
//  Created by liyufeng on 15/5/14.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "UIColor+Overlay.h"

@implementation UIColor (Overlay)


+ (UIColor *)colorBetweenStartColor:(UIColor *)startColor endColor:(UIColor *)endColor percent:(float)percent{
    const CGFloat * startCG = CGColorGetComponents(startColor.CGColor);
    const CGFloat * endCG = CGColorGetComponents(endColor.CGColor);
    float valueR = [self lerp:percent min:startCG[0] max:endCG[0]];
    float valueG = [self lerp:percent min:startCG[1]  max:endCG[1]];
    float valueB = [self lerp:percent min:startCG[2]  max:endCG[2]];
    float valueA = [self lerp:percent min:startCG[3]  max:endCG[3]];
    return [UIColor colorWithRed:valueR green:valueG blue:valueB alpha:valueA];
}

+ (float)lerp:(float)percent min:(float)nMin max:(float)nMax
{
    float result = nMin;
    result = nMin + percent * (nMax - nMin);
    return result;
}
@end
