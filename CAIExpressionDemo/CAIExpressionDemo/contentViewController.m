//
//  contentViewController.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/15.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "contentViewController.h"

@interface contentViewController ()

@end

@implementation contentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%s",__func__);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%s",__func__);
}
@end
