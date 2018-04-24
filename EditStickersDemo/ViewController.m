//
//  ViewController.m
//  EditStickersDemo
//
//  Created by yu on 2018/4/3.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "ViewController.h"
#import "PBTPublishStickerView.h"

@interface ViewController ()<PBTPublishStickerViewDelegate>

@property (nonatomic,strong) NSMutableArray * stickerLists;

@property (nonatomic,strong) UIButton * addButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.addButton];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat viewWidth = 100;
    CGFloat viewHeight = 44;
    self.addButton.frame = CGRectMake((screenWidth - viewWidth)/2, screenHeight - 100 - viewHeight, viewWidth, viewHeight);
}

- (void)addButtonAction {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat viewWidth = 300;
    
    PBTPublishStickerView * publishStickerView = [[PBTPublishStickerView alloc] initWithFrame:CGRectMake((screenWidth - viewWidth)/2, 100, viewWidth, viewWidth)];
    publishStickerView.stickerViewDelegate = self;
    [self.view addSubview:publishStickerView];
    [publishStickerView updateStickerWithImage:[UIImage imageNamed:@"testImage"]];
    
    [self hiddenOtherStickerStatus];
    [self.stickerLists addObject:publishStickerView];
}

#pragma mark - PBTPublishStickerViewDelegate

- (void)stickerView:(PBTPublishStickerView *)stickerView handleTap:(UIImageView *)stickerImageView {
    [self hiddenOtherStickerStatus];
    
    [self.view bringSubviewToFront:stickerView];
}

//隐藏其他贴纸编辑状态
- (void)hiddenOtherStickerStatus {
    for (int i = 0; i < self.stickerLists.count; i++) {
        PBTPublishStickerView * publishStickerView = self.stickerLists[i];
        [publishStickerView hideEditState];
    }
}

#pragma mark - 点击方法

- (void)touchAction {
    for (int i = 0; i < self.stickerLists.count; i++) {
        PBTPublishStickerView * publishStickerView = self.stickerLists[i];
        [publishStickerView hideEditState];
    }
}

#pragma mark - getter

- (UIButton *)addButton {
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] init];
        [_addButton setTitle:@"添加标签" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (NSMutableArray *)stickerLists {
    if (_stickerLists == nil) {
        _stickerLists = [[NSMutableArray alloc] init];
    }
    return _stickerLists;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
