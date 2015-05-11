//
//  DrawView.m
//  CAIExpressionDemo
//
//  Created by liyufeng on 15/5/11.
//  Copyright (c) 2015年 liyufeng. All rights reserved.
//

#import "DrawView.h"
#import <CoreText/CoreText.h>
#import "CAIExpressionParser.h"

@implementation DrawView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.attributeString) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, self.bounds );
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)(self.attributeString));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributeString length]), path, NULL);
        
        CTFrameDraw(frame, context);
        [self drawExpressionsWithContext:context frame:frame];
        
        CFRelease(frame); //5
        CFRelease(path);
        CFRelease(framesetter);
    }
//    [super drawRect:rect];
}

- (void)drawExpressionsWithContext:(CGContextRef)context frame:(CTFrameRef)frame{
    NSAttributedString * attributedString = self.attributeString;
    NSDictionary * dic = [attributedString attributesAtIndex:0 effectiveRange:NULL];
    UIFont * font = dic[NSFontAttributeName];
    CGFloat fontSize = [UIFont systemFontSize];
    if (font) {
        fontSize = font.pointSize;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    NSLog(@"line count = %ld",CFArrayGetCount(lines));
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        NSLog(@"ascent = %f,descent = %f,leading = %f",lineAscent,lineDescent,lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        NSLog(@"run count = %ld",CFArrayGetCount(runs));
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            NSLog(@"width = %f",runRect.size.width);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imageName"];
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:[CAIExpressionParser shareParser].expressionFile[imageName]];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = CGSizeMake(runRect.size.width, runRect.size.width);
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y-fontSize*0.2 ;
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
        }
    }
}

@end
