//
//  CAIContainerView.h
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/15.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAIContainerView : UIView

@property (nonatomic, weak)UIViewController *parentController;
@property (nonatomic, weak)id<UIScrollViewDelegate> scrollDelegate;
@property (nonatomic, strong)NSMutableArray *viewControllers;
@property (nonatomic, assign)NSInteger currentIndex;//当前显示
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, assign)BOOL didApear;//处理自动布局问题

- (void)updateControllers;

@end
