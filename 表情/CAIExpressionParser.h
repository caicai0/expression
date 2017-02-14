//
//  CAIExpressionParser.h
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/8.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//  特殊规定 [delete]指的不是表情而是删除键(keyboard)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CAIExpressionParser : NSObject

@property (nonatomic, strong)NSArray * expressionNames;
@property (nonatomic, strong)NSDictionary *expressionFile;

@property (nonatomic, strong)NSString *keyBoardDeleteIcon;
@property (nonatomic, strong)NSString *keyboardDeleteIconHL;

+ (CAIExpressionParser *)shareParser;

//将带有[]表情的字符转换成 attributedString
+ (NSMutableAttributedString *)attributedString:(NSString *)string;

//将attributedString中的表情转换成[]表情
+ (NSString*)expressionStringFromAttributedString:(NSAttributedString *)atString;

//计算字符串占用的高度
// warning 自定义view draw 时使用 label不用使用这个方法
+ (CGSize)fitSizeWithAttributedString:(NSAttributedString *)atString inSize:(CGSize)inSize;

//处理生成单个表情的attributedString
+ (NSAttributedString *)attributedStringWithExpressionName:(NSString *)name;

#pragma mark - 以下是对自定义的图片处理的 仅适用于中文

//任意的图片处理
+ (NSMutableAttributedString *)attributedStringWithImage:(UIImage *)image tag:(NSInteger)tag;

//同步图片与文字的大小
+ (void)updateImageSizeInAttributeString:(NSMutableAttributedString *)mtAtString;

#pragma mark - 处理<a>标签
+ (NSAttributedString *)attributedStringHandleAWithAttributeString:(NSAttributedString *)mtAtString ranges:(NSMutableArray *)ranges;

@end
