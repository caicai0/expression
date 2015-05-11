//
//  CAIExpressionParser.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/8.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "CAIExpressionParser.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CAIExpressionParser ()



@end



@implementation CAIExpressionParser


#pragma mark - C language

void RunDelegateDeallocCallback( void* refCon ){
}

CGFloat RunDelegateGetAscentCallback( void *refCon ){
    NSMutableAttributedString * attributedString = (__bridge NSMutableAttributedString *)refCon;
    NSDictionary * dic = [attributedString attributesAtIndex:0 effectiveRange:NULL];
    UIFont * font = dic[NSFontAttributeName];
    CGFloat fontSize = [UIFont systemFontSize];
    if (font) {
        fontSize = font.pointSize;
    }
    return fontSize;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    NSMutableAttributedString * attributedString = (__bridge NSMutableAttributedString *)refCon;
    NSDictionary * dic = [attributedString attributesAtIndex:0 effectiveRange:NULL];
    UIFont * font = dic[NSFontAttributeName];
    CGFloat fontSize = [UIFont systemFontSize];
    if (font) {
        fontSize = font.pointSize;
    }
    return fontSize*0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    NSMutableAttributedString * attributedString = (__bridge NSMutableAttributedString *)refCon;
    NSDictionary * dic = [attributedString attributesAtIndex:0 effectiveRange:NULL];
    UIFont * font = dic[NSFontAttributeName];
    CGFloat fontSize = [UIFont systemFontSize];
    if (font) {
        fontSize = font.pointSize;
    }
    return fontSize*1.2;
}

+ (CAIExpressionParser *)shareParser{
    static CAIExpressionParser * share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[CAIExpressionParser alloc]init];
    });
    return share;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableArray * names = [NSMutableArray array];
        NSMutableDictionary *files = [NSMutableDictionary dictionary];
        NSString * filePath = [[NSBundle mainBundle]pathForResource:@"expressions" ofType:@"plist"];
        NSArray * arr = [NSArray arrayWithContentsOfFile:filePath];
        for (NSInteger i=0; i<arr.count ;i++) {
            NSDictionary * dic = arr[i];
            NSString * expressName = dic[@"name"];
            NSString * expressFile = dic[@"image"];
            
            [names addObject:expressName];
            [files setObject:expressFile forKey:expressName];
        }
        self.expressionNames = [NSArray arrayWithArray:names];
        self.expressionFile = [NSDictionary dictionaryWithDictionary:files];
    }
    return self;
}

+ (NSMutableAttributedString *)parseString:(NSString *)string expressionArray:(NSArray **)arr{
    return [self AttributedString:string];
}

//用正则
+ (NSMutableAttributedString *)AttributedString:(NSString *)string
{
    NSError * error = nil;
    NSString *regTags = @"\\[[\\w]*\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    NSMutableAttributedString * atString = [[NSMutableAttributedString alloc]init];
    
    NSInteger index = 0;
    if (matches.count) {//如果有
        for (NSInteger i=0; i<matches.count; i++) {
            NSTextCheckingResult * match = matches[i];
            if (index <match.range.location) {//加载中间的文字
                [atString appendAttributedString:[[NSAttributedString alloc]initWithString:[string substringWithRange:NSMakeRange(index, match.range.location-index)]]];
                index = match.range.location;
            }
            NSString *mathString = [string substringWithRange:match.range];
            NSString *contentString =[mathString substringWithRange:NSMakeRange(1, mathString.length-2)];
            if ([[CAIExpressionParser shareParser].expressionNames containsObject:contentString]) {//是表情
                [atString appendAttributedString:[self attributedStringWithExpressionName:contentString withDelegateDic:atString]];
            }else{//不是表情
                [atString appendAttributedString:[[NSAttributedString alloc]initWithString:mathString]];
            }
            index = match.range.location+match.range.length;
        }
        if (index<string.length-1) {
            [atString appendAttributedString:[[NSAttributedString alloc]initWithString:[string substringWithRange:NSMakeRange(index,string.length-index)]]];
        }
    }
    
    return atString;
}

+ (NSAttributedString *)attributedStringWithExpressionName:(NSString *)name withDelegateDic:(NSMutableAttributedString *)mtAtString{
    unichar objectReplacementChar           = 0xFFFC;
    NSString *objectReplacementString       = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableAttributedString *attachText   = [[NSMutableAttributedString alloc]initWithString:objectReplacementString];
    
    CTRunDelegateCallbacks callbacks;
    callbacks.version       = kCTRunDelegateVersion1;
    callbacks.getAscent     = RunDelegateGetAscentCallback;
    callbacks.getDescent    = RunDelegateGetDescentCallback;
    callbacks.getWidth      = RunDelegateGetWidthCallback;
    callbacks.dealloc       = RunDelegateDeallocCallback;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (void*)mtAtString);
    
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)delegate,kCTRunDelegateAttributeName, nil];
    [attachText setAttributes:attr range:NSMakeRange(0, 1)];
    [attachText addAttribute:@"imageName" value:name range:NSMakeRange(0, 1)];
    CFRelease(delegate);
    return attachText;
}


@end
