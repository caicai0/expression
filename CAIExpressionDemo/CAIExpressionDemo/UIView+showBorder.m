//
//  UIView+showBourder.m
//  epubDemo
//
//  Created by liyufeng on 15/1/20.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "UIView+showBorder.h"

@implementation UIView(showBorder)

#pragma mark - 显示边界
- (void)showBorder{
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)showSubViewBorder{
    [self showBorder];
    for (UIView * view in self.subviews) {
        [view showSubViewBorder];
    }
}

#pragma mark - 打印逻辑结构

- (void)log:(NSMutableString *)str{
    printf("%s%s\n",[str cStringUsingEncoding:NSUTF8StringEncoding],[self.description cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)logSubViewsWithString:(NSMutableString *)str{
    [self log:str];
    if (self.subviews && self.subviews.count) {
        [str appendString:@"-"];
        for (UIView * view in self.subviews) {
            [view logSubViewsWithString:str];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
    }
}

- (void)logSubViews{
    NSMutableString * str = [NSMutableString stringWithString:@"-"];
    printf("%s",[@"\n\n=================logSubViews==================\n" cStringUsingEncoding:NSUTF8StringEncoding]);
    [self logSubViewsWithString:str];
    printf("%s",[@"=================logSubViews==================\n\n" cStringUsingEncoding:NSUTF8StringEncoding]);
}

#pragma mark - 搜索固定类型的view对象

- (void)findSubViewsWithClass:(Class)aclass from:(NSInteger)from to:(NSInteger)to block:(void(^)(UIView *view))block{
    if ((from>=0 || to>=0)&&(from<=to)) {
        if ([self isKindOfClass:aclass]) {
            block(self);
        }else{
            if (to>0 && self.subviews.count) {
                for (UIView * view in self.subviews) {
                    [view findSubViewsWithClass:aclass from:from-1 to:to-1 block:block];
                }
            }
        }
    }
}

- (void)findSubViewsWithClassArray:(NSArray*)classArray from:(NSInteger)from to:(NSInteger)to block:(void(^)(UIView *view))block{
    if ((from>=0 || to>=0)&&(from<=to)) {
        if ([self isKindOfClassInArray:classArray]) {
            block(self);
        }else{
            if (to>0 && self.subviews.count) {
                for (UIView * view in self.subviews) {
                    [view findSubViewsWithClassArray:classArray from:from-1 to:to-1 block:block];
                }
            }
        }
    }
}

//private
- (BOOL)isKindOfClassInArray:(NSArray *)classArray{
    BOOL result = NO;
    for (NSString * str in classArray) {
        result = result || [self isKindOfClass:NSClassFromString(str)];
    }
    return result;
}

@end
