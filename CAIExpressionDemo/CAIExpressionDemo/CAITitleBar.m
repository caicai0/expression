//
//  CAITitleBar.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/14.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "CAITitleBar.h"
#import "UIColor+Overlay.h"

#define VERNIER_SPEED 500.0

@interface CAITitleBar ()

@property (nonatomic, strong)NSMutableArray * buttons;
@property (nonatomic, strong)UIView *vernier;//游标

//UI常量
@property (nonatomic, assign)UIEdgeInsets contentInsets;
@property (nonatomic, assign)UIEdgeInsets buttonInsets;
@property (nonatomic, assign)CGFloat spacing;

@end

@implementation CAITitleBar

- (instancetype)initWithFrame:(CGRect)frame{
    frame.size.height = 40;
    self =[super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.directionalLockEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        self.vernier = [[UIView alloc]init];
        self.vernier.backgroundColor = [UIColor redColor];
        self.buttons = [NSMutableArray array];
        
        self.nomalColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        self.selectedColor = [UIColor redColor];
        
        self.contentInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        self.buttonInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.spacing = 10;
        
        self.isColorGradient = YES;
        self.isVernierFollow = YES;
        self.isAreaLocked = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self buildButtons];
    self.currentIndex = 0;
}

- (void)buildButtons{
    while (self.buttons.count) {
        UIButton * button = self.buttons[0];
        [button removeFromSuperview];
        [self.buttons removeObject:button];
    }
    CGFloat x = self.contentInsets.left;
    CGFloat y = self.contentInsets.top;
    for (NSInteger i=0; i<self.titles.count; i++) {
        UIButton *button = [self createButtonForIndex:i];
        CGRect frame = button.frame;
        frame.origin = CGPointMake(x, y);
        button.frame = frame;
        x += frame.size.width+self.spacing;
    }
    
    CGFloat width = x-self.spacing + self.contentInsets.right;
    self.scrollView.contentSize = CGSizeMake(width, self.scrollView.bounds.size.height);
    self.scrollView.contentInset = UIEdgeInsetsZero;
    [self.scrollView addSubview:self.vernier];
}

- (UIButton *)createButtonForIndex:(NSInteger)index{
    NSString * title = self.titles[index];
    UIButton * button= [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:self.nomalColor forState:UIControlStateNormal];
    CGRect rect = [button.titleLabel textRectForBounds:CGRectMake(0, 0, MAXFLOAT, MAXFLOAT) limitedToNumberOfLines:1];
    CGSize size = CGSizeMake(rect.size.width+self.buttonInsets.left+self.buttonInsets.right, rect.size.height+self.buttonInsets.top+self.buttonInsets.bottom);
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    button.frame = frame;
    [self.scrollView addSubview:button];
    [self.buttons addObject:button];
    
    button.tag = index;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (currentIndex < self.buttons.count && currentIndex >=0) {
        [self resetButtonAtIndex:_currentIndex-1];
        [self resetButtonAtIndex:_currentIndex];
        [self resetButtonAtIndex:_currentIndex+1];
        
        _currentIndex = currentIndex;
        UIButton * button = self.buttons[_currentIndex];
        [button setTitleColor:self.selectedColor forState:UIControlStateNormal];
        if (self.isAreaLocked) {
            [self lockButtonAtIndex:_currentIndex];
        }else{
            [self showButtonAtIndex:_currentIndex];
        }
        
        
        //游标
        CGRect frame = button.frame;
        frame.origin.y = self.bounds.size.height-2;
        frame.size.height = 2;
        
        NSTimeInterval time = ABS(self.vernier.center.x-button.center.x)/VERNIER_SPEED;
        
        [UIView animateWithDuration:MIN(time, 0.2) animations:^{
            self.vernier.frame = frame;
        }];
    }
}

// 重置button 状态
- (void)resetButtonAtIndex:(NSInteger)index{
    if (index < self.buttons.count && index >=0){
        UIButton * button = self.buttons[index];
        [button setTitleColor:self.nomalColor forState:UIControlStateNormal];
    }
}

// showButton 如果没有完全显示 移动到显示区间
- (void)showButtonAtIndex:(NSInteger)index{
    if (index < self.buttons.count && index >=0){
        UIButton * button = self.buttons[index];
        if (button.frame.origin.x<self.scrollView.contentOffset.x) {
            CGFloat offsetx = button.frame.origin.x-self.spacing/2;
            [self.scrollView setContentOffset:CGPointMake(offsetx, self.scrollView.contentOffset.y) animated:YES];
        }
        if ((button.frame.origin.x+button.frame.size.width)>(self.scrollView.contentOffset.x+self.scrollView.bounds.size.width)) {
            CGFloat offsetx = button.frame.origin.x+button.frame.size.width+self.spacing/2-self.scrollView.bounds.size.width;
            [self.scrollView setContentOffset:CGPointMake(offsetx, self.scrollView.contentOffset.y) animated:YES];
        }
    }
}
//lockArea
- (void)lockButtonAtIndex:(NSInteger)index{
    if (index < self.buttons.count && index >=0){
        UIButton * button = self.buttons[index];
        CGFloat centerx = button.center.x;
        CGFloat contentWidth = self.scrollView.contentSize.width;
        CGFloat scrollWidth = self.scrollView.bounds.size.width;
        CGFloat offsetX = 0;
        if (0<=centerx && centerx<scrollWidth/2) {
            offsetX = 0;
        }else if(contentWidth-scrollWidth/2<centerx &&centerx<=contentWidth){
            offsetX = contentWidth - scrollWidth;
        }else{
            offsetX = centerx - scrollWidth/2;
        }
        [self.scrollView setContentOffset:CGPointMake(offsetX, self.scrollView.contentOffset.y) animated:YES];
    }
}

- (void)buttonClicked:(UIButton *)button{
    self.currentIndex = button.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleBar:didSelectedIndex:)]) {
        [self.delegate titleBar:self didSelectedIndex:button.tag];
    }
}

- (void)setOffset:(CGFloat)offset{
    _offset = offset;
    CGFloat percent = ABS(_offset);
    
    //关键值过渡
    if (percent>=1) {
        if (offset>=0&&self.currentIndex+1<self.buttons.count) {
            self.currentIndex = self.currentIndex +1;
            return;
        }
        if (offset<=0&&self.currentIndex-1>=0) {
            self.currentIndex = self.currentIndex -1;
            return;
        }
    }
    
    //颜色渐变
    if(self.isColorGradient){
        UIButton *fromB = self.buttons[self.currentIndex];
        UIButton * toB = nil;
        if (offset>=0&&self.currentIndex+1<self.buttons.count) {
            toB = self.buttons[self.currentIndex+1];
        }else if(offset<=0&&self.currentIndex-1>=0){
            toB = self.buttons[self.currentIndex-1];
        }
        if (toB) {
            [fromB setTitleColor:[UIColor colorBetweenStartColor:self.selectedColor endColor:self.nomalColor percent:percent] forState:UIControlStateNormal];
            [toB setTitleColor:[UIColor colorBetweenStartColor:self.nomalColor endColor:self.selectedColor percent:(percent)] forState:UIControlStateNormal];
        }
    }
    
    //游标跟随
    if (self.isVernierFollow) {
        UIButton *fromB = self.buttons[self.currentIndex];
        UIButton * toB = nil;
        if (offset>=0&&self.currentIndex+1<self.buttons.count) {
            toB = self.buttons[self.currentIndex+1];
        }else if(offset<=0&&self.currentIndex-1>=0){
            toB = self.buttons[self.currentIndex-1];
        }
        if (toB) {
            CGFloat width = fromB.bounds.size.width + percent*(toB.bounds.size.width - fromB.bounds.size.width);
            CGFloat centerx = fromB.center.x + percent*(toB.center.x - fromB.center.x);
            CGRect frame = CGRectMake(centerx-width/2, self.bounds.size.height-2, width, 2);
            NSTimeInterval time = (centerx - self.vernier.center.x)/VERNIER_SPEED;
            [UIView animateWithDuration:MIN(time, 0.2) animations:^{
                self.vernier.frame = frame;
            }];
        }
    }
}
@end
