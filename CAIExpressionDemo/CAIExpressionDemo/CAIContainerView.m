//
//  CAIContainerView.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/15.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "CAIContainerView.h"

#define SPACE 10.0

typedef NS_ENUM(NSInteger, controllerStatus){
    KCSViewdidLoad,
    KCSViewWillApear,
    KCSViewDidApear,
    KCSViewWillDisapear,
    KCSViewDidDisapear
} ContollerStatus;

@interface CAIContainerView ()<UIScrollViewDelegate>

@property (nonatomic, strong)NSMutableArray *didAddedControllers;
@property (nonatomic, strong)NSMutableArray *controllerStatus;

@end

@implementation CAIContainerView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.didAddedControllers = [NSMutableArray array];
    self.controllerStatus = [NSMutableArray array];
    
    self.clipsToBounds = YES;
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width+SPACE, self.bounds.size.height);
    self.scrollView.contentInset = UIEdgeInsetsZero;
    [self updateViewControllersFrame];
}

- (void)setFrame:(CGRect)frame{
    if (!CGRectEqualToRect(self.frame,frame)) {
        [super setFrame:frame];
        self.scrollView.frame = self.bounds;
        [self updateViewControllersFrame];
    }else{
        [super setFrame:frame];
    }
}

- (void)setViewControllers:(NSMutableArray *)viewControllers{
    for (UIViewController *controller in _viewControllers) {
        [self removeController:controller];
        
    }
    _viewControllers = viewControllers;
    [self updateControllers];
    self.currentIndex = 0;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex != currentIndex) {
        [self disApearControllerAtIndex:_currentIndex];
        _currentIndex = currentIndex;
        [self showControllerAtIndex:_currentIndex];
    }
}

- (void)setDidApear:(BOOL)didApear{
    _didApear = didApear;
    NSInteger index  = (NSInteger)(self.scrollView.contentOffset.x/self.scrollView.bounds.size.width);
    [self showControllerAtIndex:index];
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)updateViewControllersFrame{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    for (NSInteger i=0; i<self.didAddedControllers.count; i++) {
        UIViewController * controller = self.didAddedControllers[i];
        controller.view.frame = CGRectMake((width+SPACE)* i, 0, width, height);
    }
    [self updateContentSize];
}

- (void)updateControllers{
    for (NSInteger i=0; i<self.didAddedControllers.count; i++) {
        UIViewController * controller = self.didAddedControllers[i];
        if (![self.viewControllers containsObject:controller]) {
            [self removeController:controller];
        }
    }
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    for (NSInteger i=0; i<self.viewControllers.count; i++) {
        UIViewController * controller = self.viewControllers[i];
        if (!controller.view.superview) {
            [self addController:controller frame:CGRectMake((width+SPACE)* i, 0, width, height)];
        }
    }
    [self updateViewControllersFrame];
}
- (void)updateContentSize{
    self.scrollView.contentSize = CGSizeMake((self.bounds.size.width+SPACE) * self.viewControllers.count, self.scrollView.bounds.size.height);
}

- (void)removeController:(UIViewController *)controller{
    [controller.view removeFromSuperview];
    [self.controllerStatus removeObjectAtIndex:[self.didAddedControllers indexOfObject:controller]];
    [self.didAddedControllers removeObject:controller];
}

- (void)addController:(UIViewController *)controller frame:(CGRect)frame{
    [controller willMoveToParentViewController:self.parentController];
    [self.parentController addChildViewController:controller];
    [self.scrollView addSubview:controller.view];
    [controller didMoveToParentViewController:self.parentController];
    
    [self.didAddedControllers addObject:controller];
    [self.controllerStatus addObject:@(KCSViewdidLoad)];
}

- (void)showControllerAtIndex:(NSInteger )index{
    if (0<=index && index<self.didAddedControllers.count) {
        UIViewController *controller = self.didAddedControllers[index];
        controllerStatus status = [self.controllerStatus[index]integerValue];
        if (status == KCSViewDidApear) {
        }else if(status == KCSViewdidLoad){
            [controller beginAppearanceTransition:YES animated:NO];
            [controller endAppearanceTransition];
        }else if (status == KCSViewWillApear){
            [controller endAppearanceTransition];
        }
        [self.controllerStatus replaceObjectAtIndex:index withObject:@(KCSViewDidApear)];
    }
}

- (void)willApearControllerAtIndex:(NSInteger)index{
    if (0<=index && index<self.didAddedControllers.count) {
        UIViewController *controller = self.didAddedControllers[index];
        controllerStatus status = [self.controllerStatus[index]integerValue];
        if (status != KCSViewDidApear) {
            if (status != KCSViewWillApear) {
                [controller beginAppearanceTransition:YES animated:NO];
            }
            [self.controllerStatus replaceObjectAtIndex:index withObject:@(KCSViewWillApear)];
        }
    }
}

- (void)disApearControllerAtIndex:(NSInteger)index{
    if (0<=index && index<self.didAddedControllers.count) {
        [self.controllerStatus replaceObjectAtIndex:index withObject:@(KCSViewdidLoad)];
    }
}

- (void)handleScrollViewWhenDidScroll:(UIScrollView *)scrollView{
    if(self.didApear){
        CGFloat count = (scrollView.contentOffset.x/scrollView.bounds.size.width);
        NSInteger index = (NSInteger)count;
        NSInteger index2 = ceilf(count);
        [self willApearControllerAtIndex:index];
        [self willApearControllerAtIndex:index2];
    }
}

- (void)handleScrollViewWhenDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index  = (NSInteger)(scrollView.contentOffset.x/scrollView.bounds.size.width);
    self.currentIndex = index;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollDelegate scrollViewDidScroll:scrollView];
    }
    [self handleScrollViewWhenDidScroll:scrollView];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.scrollDelegate scrollViewDidZoom:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollDelegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.scrollDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollDelegate scrollViewDidEndDecelerating:scrollView];
    }
    [self handleScrollViewWhenDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.scrollDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.scrollDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.scrollDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.scrollDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.scrollDelegate scrollViewDidScrollToTop:scrollView];
    }
}

@end
