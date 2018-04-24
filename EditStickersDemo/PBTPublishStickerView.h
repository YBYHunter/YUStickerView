//
//  PBTPublishStickerView.h
//  EditStickersDemo
//
//  Created by yu on 2018/4/4.
//  Copyright © 2018年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBTPublishStickerView;
@protocol PBTPublishStickerViewDelegate <NSObject>

- (void)stickerView:(PBTPublishStickerView *)stickerView handleTap:(UIImageView *)stickerImageView;

@end

@interface PBTPublishStickerView : UIView

@property (nonatomic,weak) id<PBTPublishStickerViewDelegate> stickerViewDelegate;

/**
 当前是否进入编辑状态
 只读
 currntHandlesHidden == YES 非编辑状态
 currntHandlesHidden == NO  编辑状态
 */
@property (nonatomic,assign,readonly) BOOL currntEditStateHidden;

/**
 更新贴纸内容

 @param image uiimage 贴纸
 */
- (void)updateStickerWithImage:(UIImage *)image;

//根据参数刷新贴纸

/**
 进入编辑状态
 */
- (void)showEditState;

/**
 隐藏编辑状态
 */
- (void)hideEditState;





//时间戳
//贴纸中心点
//角度
//放大









@end
