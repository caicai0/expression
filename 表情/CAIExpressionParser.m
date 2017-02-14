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
#import "CAITextAttachment.h"

@interface CAIExpressionParser ()

@end

@implementation CAIExpressionParser

#pragma mark - OC

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
        NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSDictionary * buttonIconDic = dic[@"keyBoardDelegateIcon"];
        NSArray * arr = dic[@"expressions"];
        for (NSInteger i=0; i<arr.count ;i++) {
            NSDictionary * dic = arr[i];
            NSString * expressName = dic[@"name"];
            NSString * expressFile = dic[@"image"];
            
            [names addObject:expressName];
            [files setObject:expressFile forKey:expressName];
        }
        self.expressionNames = [NSArray arrayWithArray:names];
        self.expressionFile = [NSDictionary dictionaryWithDictionary:files];
        self.keyBoardDeleteIcon = buttonIconDic[@"normal"];
        self.keyboardDeleteIconHL = buttonIconDic[@"heightLight"];
    }
    return self;
}

+ (NSMutableAttributedString *)attributedString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    NSMutableAttributedString * atString = [[NSMutableAttributedString alloc]init];
    NSError * error = nil;
    NSString *regTags = @"\\[[\\w]*\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];

    
    NSInteger index = 0;
    if (matches.count) {//如果有
        for (NSInteger i=0; i<matches.count; i++) {
            NSTextCheckingResult * match = matches[i];
            if (index <match.range.location) {//加载中间的文字
                [atString appendAttributedString:[[NSAttributedString alloc]initWithString:[string substringWithRange:NSMakeRange(index, match.range.location-index)]]];
            }
            NSString *mathString = [string substringWithRange:match.range];
            NSString *contentString =[mathString substringWithRange:NSMakeRange(1, mathString.length-2)];
            if ([[CAIExpressionParser shareParser].expressionNames containsObject:contentString]) {//是表情
                [atString appendAttributedString:[self attributedStringWithExpressionName:contentString]];
            }else{//不是表情
                [atString appendAttributedString:[[NSAttributedString alloc]initWithString:mathString]];
            }
            index = match.range.location+match.range.length;
        }
        if (index<string.length) {
            [atString appendAttributedString:[[NSAttributedString alloc]initWithString:[string substringWithRange:NSMakeRange(index,string.length-index)]]];
        }
    }else{
        [atString appendAttributedString:[[NSAttributedString alloc]initWithString:string]];
    }
    return atString;
}

+ (NSAttributedString *)attributedStringWithExpressionName:(NSString *)name{
    CAITextAttachment *attachment=[[CAITextAttachment alloc]initWithData:nil ofType:nil];
    NSString * imageName = [CAIExpressionParser shareParser].expressionFile[name];
    UIImage *img= [UIImage imageNamed:imageName];
    attachment.image=img;
    NSAttributedString *text=[NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *atString = [[NSMutableAttributedString alloc]initWithAttributedString:text];
    return atString;
}

+ (NSString*)expressionStringFromAttributedString:(NSAttributedString *)atString{
    NSString * string = atString.string;
    NSError * error = nil;
    unichar objectReplacementChar = 0xFFFC;
    NSString *regTags = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    
    NSInteger index = 0;
    NSMutableString *mString = [NSMutableString string];
    if (matches.count) {
        for (NSInteger i=0; i<matches.count; i++) {
            NSTextCheckingResult * match = matches[i];
            if (index <match.range.location) {//加载中间的文字
                [mString appendString:[string substringWithRange:NSMakeRange(index, match.range.location-index)]];
                index = match.range.location;
            }
            NSDictionary * dic = [atString attributesAtIndex:match.range.location effectiveRange:NULL];
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                NSString * expressionName = dic[@"imageName"];
                if ([[CAIExpressionParser shareParser].expressionNames containsObject:expressionName]) {
                    //判定为表情
                    [mString appendFormat:@"[%@]",expressionName];
                    index++;
                }
            }
        }
    }
    if (index <string.length) {//加载中间的文字
        [mString appendString:[string substringWithRange:NSMakeRange(index, string.length-index)]];
    }
    return mString;
}

+ (CGSize)fitSizeWithAttributedString:(NSAttributedString *)atString inSize:(CGSize)inSize{
    inSize.height = MAXFLOAT;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)(atString));
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, atString.length), NULL, inSize, NULL);
    suggestSize.width = inSize.width;
    return suggestSize;
}

#pragma mark - 以下是对自定义的图片处理的 仅适用于中文

+ (NSAttributedString *)attributedStringWithImage:(UIImage *)image tag:(NSInteger)tag{
    if (image) {
        NSTextAttachment *attachment=[[NSTextAttachment alloc]init];
        attachment.image = image;
        attachment.bounds= CGRectMake(0, 0, image.size.width, image.size.height);
        NSAttributedString *text=[NSAttributedString attributedStringWithAttachment:attachment];
        NSMutableAttributedString *atString = [[NSMutableAttributedString alloc]initWithAttributedString:text];
        //设置标签
        [atString addAttribute:@"tag" value:@(tag) range:NSMakeRange(0, 1)];
        [atString addAttribute:@"image" value:image range:NSMakeRange(0, 1)];
        return atString;
    }else{
        return [[NSAttributedString alloc]initWithString:@""];
    }
    
}

+ (void)updateImageSizeInAttributeString:(NSMutableAttributedString *)mtAtString{
    NSString * string = mtAtString.string;
    NSError * error = nil;
    unichar objectReplacementChar = 0xFFFC;
    NSString *regTags = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    
    for(NSInteger i=0;i<matches.count;i++){
        NSTextCheckingResult * match = matches[i];
        NSDictionary * dic = [mtAtString attributesAtIndex:match.range.location effectiveRange:NULL];
        if (dic) {
            NSTextAttachment *attachment = dic[@"NSAttachment"];
            UIImage * image = dic[@"image"];
            if (image) {
                CGFloat fontSize = [UIFont systemFontSize];
                UIFont * font = dic[NSFontAttributeName];
                if (font) {
                    fontSize = font.pointSize;
                }
                attachment.bounds = CGRectMake(0, -fontSize*0.2, fontSize*1.2*image.size.width/image.size.height, fontSize*1.2);
            }
        }
    }
}

#pragma mark - <a> 标签处理

+ (NSAttributedString *)attributedStringHandleAWithAttributeString:(NSMutableAttributedString *)mtAtString{
    NSString * string = mtAtString.string;
    NSError * error = nil;
    NSString *regTags = @"<a href=\\\"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?\\\">[^<]*</a>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];

    NSMutableAttributedString *atString = [[NSMutableAttributedString alloc]init];
    NSInteger index = 0;
    if (matches.count) {//如果有
        for (NSInteger i=0; i<matches.count; i++) {
            NSTextCheckingResult * match = matches[i];
            if (index <match.range.location) {//加载中间的文字
                NSAttributedString *aString = [mtAtString attributedSubstringFromRange:NSMakeRange(index,match.range.location-index)];
                [atString appendAttributedString:aString];
            }
            NSString *mathString = [string substringWithRange:match.range];
            NSAttributedString * mathAtString = [mtAtString attributedSubstringFromRange:match.range];
            
            NSError * error = nil;
            NSString *regTags = @"<a href=\\\"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?\\\">";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *matches2 = [regex matchesInString:mathString options:NSMatchingReportProgress range:NSMakeRange(0, [mathString length])];
            if (matches2 && matches2.count == 1) {
                NSTextCheckingResult * match = matches2[0];
                NSString * aString = [mathString substringWithRange:match.range];
                NSString * aHeader = @"<a href=\"";
                NSString * href = [aString substringWithRange:NSMakeRange(aHeader.length, match.range.length-aHeader.length-2)];
                NSAttributedString *aContent = [mathAtString attributedSubstringFromRange:NSMakeRange(match.range.length, mathString.length-match.range.length-4)];
                NSMutableAttributedString *AContent = [[NSMutableAttributedString alloc]initWithAttributedString:aContent];
                NSURL * url = [NSURL URLWithString:href];
                if (url && [url isKindOfClass:[NSURL class]] && AContent.length) {
                    [AContent addAttribute:NSLinkAttributeName value:url range:NSMakeRange(0, AContent.length)];
                    [atString appendAttributedString:AContent];
                }
            }
            index = match.range.location+match.range.length;
        }
        if (index<string.length) {
            [atString appendAttributedString:[[NSAttributedString alloc]initWithString:[string substringWithRange:NSMakeRange(index,string.length-index)]]];
        }
    }else{
        [atString appendAttributedString:[[NSAttributedString alloc]initWithString:string]];
    }
    return atString;
}

@end
