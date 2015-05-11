//
//  main.m
//  createPlist
//
//  Created by liyufeng on 15/5/8.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAIExpressionParser.h"

void ceshi(){
   
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        ceshi();
    }
    return 0;
}
void createPlist(){
    NSString * namePath = @"/Users/liyufeng/git/github/expression/表情/name.text";
    NSString * nameString = [NSString stringWithContentsOfFile:namePath encoding:NSUTF8StringEncoding error:nil];
    NSArray * names = [nameString componentsSeparatedByString:@"\n"];
    NSMutableArray * marr = [NSMutableArray array];
    for (NSInteger i=0; i<names.count; i++) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:names[i] forKey:@"name"];
        [dic setObject:[NSString stringWithFormat:@"Expression_%ld",i+1] forKey:@"image"];
        [marr addObject:dic];
    }
    
    [marr writeToFile:@"/Users/liyufeng/git/github/expression/表情/expressions.plist" atomically:YES];
    
    NSArray * arr = [NSArray arrayWithContentsOfFile:@"/Users/liyufeng/git/github/expression/表情/expressions.plist"];
    NSLog(@"%@",arr);
}

