//
//  CAIExpressionParser.h
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/8.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAIExpressionParser : NSObject

@property (nonatomic, strong)NSArray * expressionNames;
@property (nonatomic, strong)NSDictionary *expressionFile;

+ (CAIExpressionParser *)shareParser;

+ (NSMutableAttributedString *)parseString:(NSString *)string expressionArray:(NSArray **)arr;
@end
