//
//  ViewController.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/8.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "ViewController.h"
#import "CAIExpressionParser.h"
#import "DrawView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    NSString *string = @"\n\n\n\n\n\n[微笑]RichTextBox控件允许用户输入和编辑文本的同时提供了[大哭]比普通的TextBox控件更高级的格式特征。 RichTextBox控件提供了数个有用的特征[微笑]，你可以在控件中安排文本的格式。[微笑]要改变文本的格式，[大哭]必须先选中该文本。只有选中的文本才可以编排字符和段落的格式。https://github.com额/有了这些属性，就可以设置[大哭]文本使用粗体，改变[大哭]字体的颜色，创建超底稿和子底稿。[微笑]也可以设置左右缩排或不缩排，从而调整段落的格式。 RichTextBox控件可以打开和保存RTF文件或普通的ASCII文本文件。你可以使用控件的方法（LoadFile[微笑]SaveFile）直接读和写文件 RichTextBox控件使用集合支https://github.com持嵌入的对象。每个嵌入控件中的对象都表示为一个[1]对象。这允许文档中创建的控件可以包含其他控件或文档。https://github.com/ 例如，可以创建一个包含报表、Microsoft Word文档或任何在系统中注册的其他OLE对象的文档。要在RichTextBox控件中插入对象，可以简单地拖住一个文件（如使用Windows 95的Explorerwww.chiphell.com/或其他应用程序（如Microsoft Word）中所用文件的加亮部分（选择部分），将其直接放到该RichTextBox控件上。http://www.cnblogs.com/CCSSPP/";
    
    NSArray * arr = nil;
    NSMutableAttributedString * atstring = [CAIExpressionParser parseString:string expressionArray:&arr];
    NSDictionary *attribs = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    [atstring addAttributes:attribs range:NSMakeRange(0, atstring.length)];
    
    DrawView *label = [[DrawView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:label];
    label.attributeString = atstring;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = @"表情展示, 高度计算";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
