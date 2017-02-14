//
//  CAITextAttachment.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 2017/2/14.
//  Copyright © 2017年 liyufeng. All rights reserved.
//

#import "CAITextAttachment.h"

@implementation CAITextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)

{
    return CGRectMake( 0 , -lineFrag.size.height*0.2 , lineFrag.size.height , lineFrag.size.height );
}

@end
