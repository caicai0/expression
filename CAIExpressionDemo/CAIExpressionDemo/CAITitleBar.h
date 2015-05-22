//
//  CAITitleBar.h
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/14.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAITitleBar;
@protocol TitleBarDelegate <NSObject>

@optional
- (void)titleBar:(CAITitleBar *)titleBar didSelectedIndex:(NSInteger)index;

@end

@interface CAITitleBar : UIView

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, weak)id<TitleBarDelegate> delegate;

//要显示的标题,设置后默认 currentindex = 0;
@property (nonatomic, strong)NSArray *titles;

//两个状态的颜色设置 色彩空间必须是 RGBA
@property (nonatomic, strong)UIColor *nomalColor;
@property (nonatomic, strong)UIColor *selectedColor;

//当前的选中
@property (nonatomic, assign)NSInteger currentIndex;

//偏移量区间[-1,1] 相对依据currentIndex
@property (nonatomic, assign)CGFloat offset;

//功能开关
@property (nonatomic, assign)BOOL isColorGradient;//是否开启颜色渐变
@property (nonatomic, assign)BOOL isVernierFollow;//是否开启游标跟随
@property (nonatomic, assign)BOOL isAreaLocked;//是否锁定显示区

@end
