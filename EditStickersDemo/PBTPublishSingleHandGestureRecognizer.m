//
//  PBTPublishSingleHandGestureRecognizer.m
//  EditStickersDemo
//
//  Created by yu on 2018/4/8.
//  Copyright © 2018年 yu. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "PBTPublishSingleHandGestureRecognizer.h"

@interface PBTPublishSingleHandGestureRecognizer ()

@property (weak, nonatomic) UIView * anchorView;

@end

@implementation PBTPublishSingleHandGestureRecognizer

- (nonnull instancetype)initWithTarget:(nullable id)target action:(nullable SEL)action anchorView:(nonnull UIView *)anchorView {
    
    self = [super initWithTarget:target action:action];
    if (self) {
        _anchorView = anchorView;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[event touchesForGestureRecognizer:self] count] > 1) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
    } else {
        self.state = UIGestureRecognizerStateChanged;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint anchorViewCenter = _anchorView.center;
    CGPoint currentPoint = [touch locationInView:_anchorView.superview];
    CGPoint previousPoint = [touch previousLocationInView:_anchorView.superview];
    
    CGFloat currentRotation = atan2f((currentPoint.y - anchorViewCenter.y), (currentPoint.x - anchorViewCenter.x));
    CGFloat previousRotation = atan2f((previousPoint.y - anchorViewCenter.y), (previousPoint.x - anchorViewCenter.x));
    
    CGFloat currentRadius = [self distanceBetweenFirstPoint:currentPoint secondPoint:anchorViewCenter];
    CGFloat previousRadius = [self distanceBetweenFirstPoint:previousPoint secondPoint:anchorViewCenter];
    CGFloat scale = currentRadius / previousRadius;
    
    [self setRotation:(currentRotation - previousRotation)];
    [self setScale:scale];
}

- (CGFloat)distanceBetweenFirstPoint:(CGPoint)first secondPoint:(CGPoint)second {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateEnded;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
    self.rotation = 0;
    self.scale = 1;
}
@end
