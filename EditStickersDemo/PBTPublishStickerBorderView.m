//
//  PBTPublishStickerBorderView.m
//  EditStickersDemo
//
//  Created by yu on 2018/4/4.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "PBTPublishStickerBorderView.h"

@implementation PBTPublishStickerBorderView



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //优化边缘虚问题
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextAddRect(context, self.bounds);
    CGContextStrokePath(context);
    
    CGRect newRect = CGRectInset(self.bounds, 1, 1);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context, newRect);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}
















@end
