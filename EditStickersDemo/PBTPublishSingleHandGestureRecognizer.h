//
//  PBTPublishSingleHandGestureRecognizer.h
//  EditStickersDemo
//
//  Created by yu on 2018/4/8.
//  Copyright © 2018年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBTPublishSingleHandGestureRecognizer : UIGestureRecognizer

@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) CGFloat rotation;

- (nonnull instancetype)initWithTarget:(nullable id)target action:(nullable SEL)action anchorView:(nonnull UIView *)anchorView;

- (void)reset;

@end
