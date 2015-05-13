//
//  ExpressSowViewController.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/12.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "ExpressSowViewController.h"
#import "CAIExpressionParser.h"

@interface ExpressSowViewController ()
@property (nonatomic, strong)NSMutableAttributedString *mtatString;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, strong)UILabel *label;

@end

@implementation ExpressSowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * string = @"[微笑]RichTextBox控件允许用户输入和编辑文本的同时提供了[大哭]比普通的TextBox控件更高级的格式特征。 RichTextBox控件提供了数个有用的特征[微笑]，你可以在控件中安排文本的格式。[微笑]要改变文本的格式，[大哭]必须先选中该文本。只有选中的文本才可以编排字符和段落的格式。https://github.com额/有了这些属性，就可以设置[大哭];lasdfj;lasdkjf;laskdjf;lsadjf;lasdjf;sdkjf;sdajf;asdklfjsdkaljflasdjf;lasdjf;lksdjfk;djsf;lkajsdklfjads;ljf;ladjsfkafiuiwejfjiarjf;asdjf;sldjf;lsdkjf;alsdjklfj;saldfLoadFile[微笑]SaveFile";
    self.mtatString = [CAIExpressionParser attributedString:string];
    [self.mtatString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, self.mtatString.length)];
    [CAIExpressionParser updateExpressionSizeInAttributeString:self.mtatString];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 0)];
    [self.view addSubview:label];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.numberOfLines = 0;
    label.attributedText = self.mtatString;
    CGRect ract = [label textRectForBounds:CGRectMake(0, 0, label.bounds.size.width, MAXFLOAT) limitedToNumberOfLines:INT_MAX];
    CGRect frame = label.frame;
    frame.size.height = ract.size.height;
    label.frame =frame;
    self.label = label;
    
    self.slider.minimumValue = 5;
    self.slider.maximumValue = 50;
    self.slider.value = 15;
    [self.slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sliderChange:(UISlider *)slider{
    [self.mtatString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:slider.value] range:NSMakeRange(0, self.mtatString.length)];
    [CAIExpressionParser updateExpressionSizeInAttributeString:self.mtatString];
    self.label.attributedText = self.mtatString;
    CGRect ract = [self.label textRectForBounds:CGRectMake(0, 0, self.label.bounds.size.width, MAXFLOAT) limitedToNumberOfLines:INT_MAX];
    CGRect frame = self.label.frame;
    frame.size.height = ract.size.height;
    self.label.frame =frame;
//    [self.label setNeedsDisplay];
}

@end
