//
//  PBTPublishStickerView.m
//  EditStickersDemo
//
//  Created by yu on 2018/4/4.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "PBTPublishStickerView.h"
#import "PBTPublishStickerModel.h"                  //配置参数
#import "PBTPublishStickerBorderView.h"             //贴纸边缘线
#import "PBTPublishSingleHandGestureRecognizer.h"   //单指拖拽手势

@interface PBTPublishStickerView ()<UIGestureRecognizerDelegate>

//贴纸的边缘
@property (nonatomic,strong) PBTPublishStickerBorderView * stickerBorderView;

//贴纸内容
@property (nonatomic,strong) UIImageView * stickerImageView;

//贴纸配置参数
@property (nonatomic,strong) PBTPublishStickerModel * stickerModel;

//删除
@property (strong, nonatomic) UIImageView * deleteImageView;

//单手拖拽
@property (strong, nonatomic) UIImageView * resizeImageView;


@end

@implementation PBTPublishStickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.stickerImageView];
        [self.stickerImageView addSubview:self.stickerBorderView];
        [self addSubview:self.deleteImageView];
        [self addSubview:self.resizeImageView];
        
        self.stickerImageView.frame = CGRectInset(self.bounds, PBTPResizableViewInteractiveBorderSize, PBTPResizableViewInteractiveBorderSize);
        
        self.stickerBorderView.frame = CGRectInset(self.stickerImageView.bounds, PBTPResizableViewGlobalInset, PBTPResizableViewGlobalInset);
        [self.stickerBorderView setNeedsDisplay];
        
        CGFloat halfButtonWidth = 45;
        self.resizeImageView.frame = CGRectMake(self.stickerBorderView.center.x + self.stickerBorderView.bounds.size.width / 2 - halfButtonWidth/2, self.stickerBorderView.center.y + self.stickerBorderView.bounds.size.height / 2 - halfButtonWidth/2, halfButtonWidth, halfButtonWidth);
        
        self.deleteImageView.frame = CGRectMake(self.stickerBorderView.center.x - self.stickerBorderView.bounds.size.width / 2 - halfButtonWidth/2, self.stickerBorderView.center.y - self.stickerBorderView.bounds.size.height / 2 - halfButtonWidth/2, halfButtonWidth, halfButtonWidth);
        
        [self addAllGestures];
        
//        UIPanGestureRecognizer *panGesture = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfoDic"]];
//        [self.stickerImageView addGestureRecognizer:panGesture];
//        NSLog(@"asd");
//        [self handleMove:panGesture];
        
    }
    return self;
}



#pragma mark - Public Method

- (void)updateStickerWithImage:(UIImage *)image {
    self.stickerImageView.image = image;
}

- (void)showEditState {
    _currntEditStateHidden = NO;
    
    self.stickerBorderView.hidden = _currntEditStateHidden;
    self.deleteImageView.hidden = _currntEditStateHidden;
    self.resizeImageView.hidden = _currntEditStateHidden;
}


- (void)hideEditState {
    _currntEditStateHidden = YES;
    
    self.stickerBorderView.hidden = _currntEditStateHidden;
    self.deleteImageView.hidden = _currntEditStateHidden;
    self.resizeImageView.hidden = _currntEditStateHidden;
}
#pragma mark - Private Method


//更新按钮位置
- (void)updateControlView {
    CGPoint originalCenter = CGPointApplyAffineTransform(self.stickerImageView.center, CGAffineTransformInvert(self.stickerImageView.transform));
    self.resizeImageView.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x + self.stickerBorderView.bounds.size.width / 2.0f, originalCenter.y + self.stickerBorderView.bounds.size.height / 2.0f), self.stickerImageView.transform);
    self.deleteImageView.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x - self.stickerBorderView.bounds.size.width / 2.0f, originalCenter.y - self.stickerBorderView.bounds.size.height / 2.0f), self.stickerImageView.transform);
    
}

- (void)performShakeAnimation:(UIView *)targetView {
    [targetView.layer removeAnimationForKey:@"anim"];
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5f;
    animation.values = @[[NSValue valueWithCATransform3D:targetView.layer.transform],
                         [NSValue valueWithCATransform3D:CATransform3DScale(targetView.layer.transform, 1.05, 1.05, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DScale(targetView.layer.transform, 0.95, 0.95, 1.0)],
                         [NSValue valueWithCATransform3D:targetView.layer.transform]
                         ];
    animation.removedOnCompletion = YES;
    [targetView.layer addAnimation:animation forKey:@"anim"];
}

#pragma mark - 添加触摸事件

- (void)addAllGestures {
    //旋转手势
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [rotateGesture setDelegate:self];
    [self.stickerImageView addGestureRecognizer:rotateGesture];
    
    //放大手势
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleScale:)];
    [pinGesture setDelegate:self];
    [self.stickerImageView addGestureRecognizer:pinGesture];
    
    //移动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [self.stickerImageView addGestureRecognizer:panGesture];
    
    //单击手势
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [self.stickerImageView addGestureRecognizer:tapRecognizer];
    
    //单手拖拽手势
    PBTPublishSingleHandGestureRecognizer *singleHandGesture = [[PBTPublishSingleHandGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleHandAction:) anchorView:self];
    [self.resizeImageView addGestureRecognizer:singleHandGesture];
    
    //删除
    UITapGestureRecognizer * deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [deleteTap setNumberOfTapsRequired:1];
    [deleteTap setDelegate:self];
    [self.deleteImageView addGestureRecognizer:deleteTap];
}

#pragma mark - Handle Gestures

//点击
- (void)handleTap:(UITapGestureRecognizer *)gesture {
    
    if (gesture.view == self.stickerImageView) {
        [self performShakeAnimation:gesture.view];
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerView:handleTap:)]) {
            [self.stickerViewDelegate stickerView:self handleTap:self.stickerImageView];
        }
        [self showEditState];
    }
    else if (gesture.view == self.deleteImageView) {
        if (_currntEditStateHidden) {
            return;
        }
        [self removeFromSuperview];
    }
}

//单指移动
- (void)handleMove:(UIPanGestureRecognizer *)gesture {
    if (_currntEditStateHidden) {
        return;
    }
    CGPoint translation = [gesture translationInView:[self superview]];
    CGPoint targetPoint = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    targetPoint.x = MAX(0, targetPoint.x);
    targetPoint.y = MAX(0, targetPoint.y);
    targetPoint.x = MIN(self.superview.bounds.size.width, targetPoint.x);
    targetPoint.y = MIN(self.superview.bounds.size.height, targetPoint.y);
    
    [self setCenter:targetPoint];
    [gesture setTranslation:CGPointZero inView:[self superview]];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gesture];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userinfoDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//放大
- (void)handleScale:(UIPinchGestureRecognizer *)gesture {
    if (_currntEditStateHidden) {
        return;
    }
    CGFloat scale = gesture.scale;
    CGFloat currentScale = [[gesture.view.layer valueForKeyPath:@"transform.scale"] floatValue];
    if (scale * currentScale <= kStickerMinScale) {
        scale = kStickerMinScale / currentScale;
    } else if (scale * currentScale >= kStickerMaxScale) {
        scale = kStickerMaxScale / currentScale;
    }
    
    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, scale, scale);
    gesture.scale = 1;
    
    [self updateControlView];
}

//旋转
- (void)handleRotate:(UIRotationGestureRecognizer *)gesture {
    if (_currntEditStateHidden) {
        return;
    }
    gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
    gesture.rotation = 0;
    
    [self updateControlView];
}

//单指拖拽
- (void)handleSingleHandAction:(PBTPublishSingleHandGestureRecognizer *)gesture {
    if (_currntEditStateHidden) {
        return;
    }
    CGFloat scale = gesture.scale;
    // Scale limit
    CGFloat currentScale = [[self.stickerImageView.layer valueForKeyPath:@"transform.scale"] floatValue];
    if (scale * currentScale <= kStickerMinScale) {
        scale = kStickerMinScale / currentScale;
    } else if (scale * currentScale >= kStickerMaxScale) {
        scale = kStickerMaxScale / currentScale;
    }
    
    self.stickerImageView.transform = CGAffineTransformScale(self.stickerImageView.transform, scale, scale);
    self.stickerImageView.transform = CGAffineTransformRotate(self.stickerImageView.transform, gesture.rotation);
    [gesture reset];
    
    [self updateControlView];
}


#pragma mark - UIGestureRecognizerDelegate

//解决收拾冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ||
        [otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]] ||
        [gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]] ||
        [gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Hit Test

//解决 贴纸 超过父视图点击问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden || !self.userInteractionEnabled || self.alpha < 0.01) {
        return nil;
    }
    
    if ([self.resizeImageView pointInside:[self convertPoint:point toView:self.resizeImageView] withEvent:event]) {
        return self.resizeImageView;
    }
    if ([self.deleteImageView pointInside:[self convertPoint:point toView:self.deleteImageView] withEvent:event]) {
        return self.deleteImageView;
    }
    if ([self.stickerImageView pointInside:[self convertPoint:point toView:self.stickerImageView] withEvent:event]) {
        return self.stickerImageView;
    }
    
    return nil;
}



#pragma mark - getter

- (UIImageView *)resizeImageView {
    if (_resizeImageView == nil) {
        _resizeImageView = [[UIImageView alloc] init];
        _resizeImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _resizeImageView;
}

- (UIImageView *)deleteImageView {
    if (_deleteImageView == nil) {
        _deleteImageView = [[UIImageView alloc] init];
        _deleteImageView.backgroundColor = [UIColor blueColor];
    }
    return _deleteImageView;
}

- (UIImageView *)stickerImageView {
    if (_stickerImageView == nil) {
        _stickerImageView = [[UIImageView alloc] init];
        _stickerImageView.backgroundColor = [UIColor blueColor];
        _stickerImageView.userInteractionEnabled = YES;
    }
    return _stickerImageView;
}

- (PBTPublishStickerBorderView *)stickerBorderView {
    if (_stickerBorderView == nil) {
        _stickerBorderView = [[PBTPublishStickerBorderView alloc] init];
        
    }
    return _stickerBorderView;
}

- (PBTPublishStickerModel *)stickerModel {
    if (_stickerModel == nil) {
        _stickerModel = [[PBTPublishStickerModel alloc] init];
    }
    return _stickerModel;
}


















@end
