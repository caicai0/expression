//
//  TitleViewController.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/14.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "TitleViewController.h"
#import "CAITitleBar.h"
#import "UIView+showBorder.h"
#import "CAIContainerView.h"

@interface TitleViewController ()<TitleBarDelegate>

@property (weak, nonatomic) IBOutlet CAIContainerView *container;

@property (nonatomic, strong)CAITitleBar *titleBar;
@property (nonatomic, assign)NSInteger jumpToindex;
@end

@implementation TitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAITitleBar *titleBar = [[CAITitleBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-50, 100)];
    [self.view addSubview:titleBar];
    CGRect rect = titleBar.frame;
    rect.origin.y = 70;
    titleBar.frame = rect;
    titleBar.titles = @[@"要闻",@"要闻",@"要要闻闻",@"要闻",@"要闻要闻",@"要闻",@"要要闻闻",@"要闻",@"要闻",@"要闻",@"要闻",@"要闻"];
    self.titleBar = titleBar;
    
    self.titleBar.delegate = self;
    self.jumpToindex = -1;
    
//    [titleBar showSubViewBorder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSMutableArray * arr = [NSMutableArray array];
    for (NSInteger i=0; i<self.titleBar.titles.count; i++) {
        UIViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"scd"];
        [arr addObject:controller];
    }
    self.container.viewControllers = arr;
    self.container.parentController = self;
    self.container.scrollDelegate = self;
}


- (CGFloat)rand{
    return (rand()%1000)*1.0/1000;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.container.scrollView.directionalLockEnabled = YES;
    self.container.didApear = YES;
//    self.titleBar.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.jumpToindex<0) {
        CGFloat offset = (scrollView.contentOffset.x - self.titleBar.currentIndex*scrollView.bounds.size.width)/scrollView.bounds.size.width;
        self.titleBar.offset = offset;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = (NSInteger)(scrollView.contentOffset.x/scrollView.bounds.size.width);
    self.titleBar.currentIndex = index;
}
- (void)titleBar:(CAITitleBar *)titleBar didSelectedIndex:(NSInteger)index{
    CGFloat offset = index * self.container.scrollView.bounds.size.width;
    self.jumpToindex = index;
    [UIView animateWithDuration:0.2 animations:^{
        [self.container.scrollView setContentOffset:CGPointMake(offset, self.container.scrollView.contentOffset.y)];
        self.container.currentIndex = index;
    } completion:^(BOOL finished) {
        self.jumpToindex = -1;
    }];
}
- (IBAction)slider1:(id)sender {
}
- (IBAction)slider2:(id)sender {
}
- (IBAction)slider3:(id)sender {
}

@end
