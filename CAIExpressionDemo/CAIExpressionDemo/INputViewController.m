//
//  INputViewController.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/12.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "INputViewController.h"
#import "CAIExpressionKeyBoardView.h"
#import "CAIExpressionParser.h"

@interface INputViewController ()<CAIExpressionKeyBoardDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong)NSMutableAttributedString * astr;
@end

@implementation INputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * string = @"[微笑]RichTextBox控件允许用户输入和编辑文本的同时提供了[大哭]比普通的TextBox控件更高级的格式特征。 RichTextBox控件提供了数个有用的特征[微笑]，你可以在控件中安排文本的格式。[微笑]要改变文本的格式，[大哭]必须先选中该文本。只有选中的文本才可以编排字符和段落的格式。https://github.com额/有了这些属性，就可以设置[大哭]文本使用粗体，改变[大哭]字体的颜色，创建超底稿和子底稿。[微笑]也可以设置左右缩排或不缩排，从而调整段落的格式。 RichTextBox控件可以打开和保存RTF文件或普通的ASCII文本文件。你可以使用控件的方法（LoadFile[微笑]SaveFile";
    NSMutableAttributedString * str = [CAIExpressionParser attributedString:string];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, str.length)];
    [CAIExpressionParser updateExpressionSizeInAttributeString:str];
    self.textView.attributedText = str;
    self.astr = str;
    
    CAIExpressionKeyBoardView *view = [[CAIExpressionKeyBoardView alloc]initWithFrame:CGRectZero];
    CGRect frame = view.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height;
    view.frame = frame;
    [self.view addSubview:view];
    view.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CAIExpressionKeyBoardDelegate

- (void)keyBoard:(CAIExpressionKeyBoardView *)keyBoard didSeleted:(NSString *)expressionName{
    if ([expressionName isEqualToString:@"delete"]) {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
        NSRange range = self.textView.selectedRange;
        if (range.length) {
            [str deleteCharactersInRange:self.textView.selectedRange];
            range.length = 0;
        }else{
            if (range.location>0) {
                [str deleteCharactersInRange:NSMakeRange(range.location-1, 1)];
                range.location = range.location-1;
            }
        }
        self.textView.attributedText = str;
        self.textView.selectedRange = range; 
    }else{
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
        if (self.textView.selectedRange.length) {
            [str deleteCharactersInRange:self.textView.selectedRange];
        }
        [str insertAttributedString:[CAIExpressionParser attributedStringWithExpressionName:expressionName withDelegateDic:self.astr] atIndex:self.textView.selectedRange.location];
        NSRange range = self.textView.selectedRange;
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, str.length)];
        [CAIExpressionParser updateExpressionSizeInAttributeString:str];
        self.textView.attributedText = str;
        range.location = range.location+1;
        range.length = 0;
        self.textView.selectedRange = range;
        [self.textView setNeedsDisplay];
    }
}

@end
