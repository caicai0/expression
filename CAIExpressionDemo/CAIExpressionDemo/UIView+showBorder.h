//
//  UIView+showBourder.h
//  epubDemo
//
//  Created by liyufeng on 15/1/20.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(showBorder)

#pragma mark - 显示边界
- (void)showBorder;
- (void)showSubViewBorder;

#pragma mark - 打印逻辑结构
- (void)logSubViews;

#pragma mark - 搜索固定类型的view对象

/**
 *  处理subview中特定类型
 *
 *  @param aclass 指定类 (uiview 的子类)
 *  @param from   起始深度 0 为self
 *  @param to     终止深度 包括终止深度
 *  @param block  处理块
 */
- (void)findSubViewsWithClass:(Class)aclass from:(NSInteger)from to:(NSInteger)to block:(void(^)(UIView *view))block;

/**
 *  处理subview中特定类型
 *
 *  @param classArray 指定类 (uiview 的子类) [NSString]
 *  @param from       起始深度 0 为self
 *  @param to         终止深度 包括终止深度
 *  @param block      处理块
 */
- (void)findSubViewsWithClassArray:(NSArray*)classArray from:(NSInteger)from to:(NSInteger)to block:(void(^)(UIView *view))block;

@end
