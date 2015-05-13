//
//  ExpressShowViewController.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/8.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "ExpressShowViewController.h"
#import "CAIExpressionParser.h"

@interface ExpressShowViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISwitch *sizeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *fontSize;
@property (strong, nonatomic) NSMutableAttributedString * mtatString;

@end

@implementation ExpressShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *string = @"[微笑]RichTextBox控件允许用户输入和编辑文本的同时提供了[大哭]比普通的TextBox控件更高级的格式特征。 RichTextBox控件提供了数个有用的特征[微笑]，你可以在控件中安排文本的格式。[微笑]要改变文本的格式，[大哭]必须先选中该文本。只有选中的文本才可以编排字符和段落的格式。https://github.com额/有了这些属性，就可以设置[大哭]文本使用粗体，改变[大哭]字体的颜色，创建超底稿和子底稿。[微笑]也可以设置左右缩排或不缩排，从而调整段落的格式。 RichTextBox控件可以打开和保存RTF文件或普通的ASCII文本文件。你可以使用控件的方法（LoadFile[微笑]SaveFile";
    NSMutableAttributedString * mtAtString = [CAIExpressionParser attributedString:string];
    self.label.numberOfLines = 7;
    self.label.attributedText = mtAtString;
    self.label.layer.borderColor = [UIColor redColor].CGColor;
    self.label.layer.borderWidth =1;
    
    self.slider.minimumValue = 2;
    self.slider.maximumValue = 50;
    self.slider.value = [UIFont systemFontSize];
    [self.slider addTarget:self action:@selector(fontSizeChange:) forControlEvents:UIControlEventValueChanged];
    
    self.mtatString = mtAtString;
    
    [self.sizeSwitch addTarget:self action:@selector(fontsizeUpdate:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fontSizeChange:(UISlider *)slider{
    [self.mtatString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:slider.value] range:NSMakeRange(0, self.mtatString.length)];
    if(self.sizeSwitch.on){
        [CAIExpressionParser updateExpressionSizeInAttributeString:self.mtatString];
    }
    self.fontSize.text = [NSString stringWithFormat:@"fontSize:%f",slider.value];
    self.label.attributedText = self.mtatString;
}

- (void)fontsizeUpdate:(UISwitch *)sizeSwitch{
    if (sizeSwitch.on) {
        [CAIExpressionParser updateExpressionSizeInAttributeString:self.mtatString];
        self.label.attributedText = self.mtatString;
        [self.label setNeedsDisplay];
    }
}

@end
