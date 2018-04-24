//
//  PBTPublishStickerModel.h
//  EditStickersDemo
//
//  Created by yu on 2018/4/8.
//  Copyright © 2018年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//初始化大小问题
//选中白线 距离 贴纸边缘
#define PBTPResizableViewGlobalInset 0.0
//贴纸 距离 父视图view边缘
#define PBTPResizableViewInteractiveBorderSize 0.0
//最小比例
#define kStickerMinScale 0.5f
//最大比例
#define kStickerMaxScale 2.0f

@interface PBTPublishStickerModel : NSObject

/**
 贴纸的最小距离
 */
@property (nonatomic) CGFloat minWidth;

/**
 贴纸的最小距离
 */
@property (nonatomic) CGFloat minHeight;

/**
 是否开启旋转功能
 默认 YES 开启
 */
@property (nonatomic) BOOL isOpenResizing;

/**
 是否开启删除功能
 默认 YES 开启
 */
@property (nonatomic) BOOL isOpenDelete;

/**
 单指旋转按钮
 可选参数 默认有值
 */
@property (nonatomic,strong) UIImage * resizingImage;

/**
 删除按钮
 可选参数 默认有值
 */
@property (nonatomic,strong) UIImage * deleteImage;












@end
