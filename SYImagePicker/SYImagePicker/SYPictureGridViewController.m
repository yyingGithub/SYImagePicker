//
//  SYPictureGridViewController.m
//  SYImagePicker
//
//  Created by 申颖 on 15/12/19.
//  Copyright © 2015年 Ying. All rights reserved.
//

#import "SYPictureGridViewController.h"
#import "SYPicturePreviewViewController.h"
#import "SYPictueeGridLayout.h"
#import "SYPictureGridCell.h"
#import "SYCounterButton.h"

#import "SYAlbumManager.h"
#pragma mark - 常量定义
/// 可重用标识符
static NSString *const kSYGridCellId = @"SYGridCellId";
@interface SYPictureGridViewController ()<SYPictureGridCellDelegate>
/// 预览按钮
@property (nonatomic) UIBarButtonItem *previewItem;
/// 完成按钮
@property (nonatomic) UIBarButtonItem *doneItem;
/// 选择计数按钮
@property (nonatomic) SYCounterButton *counterButton;

@end

@implementation SYPictureGridViewController

//static NSString * const reuseIdentifier = @"Cell";

#pragma mark - 构造函数
- (instancetype)init {
    self = [super initWithCollectionViewLayout:[[SYPictueeGridLayout alloc] init]];
    if (self) {
        // 加载相册完成后刷新数据
        __weak typeof(self) weakSelf = self;
        _albumManager = [[SYAlbumManager alloc] initWithCompleted:^(NSString *title) {
            [weakSelf.collectionView reloadData];
            
            weakSelf.title = title;
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)dealloc {
    NSLog(@"%@ %s", self.class, __FUNCTION__);
}

#pragma mark - 监听方法
/// 点击取消按钮
- (void)clickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 点击完成按钮
- (void)clickFinishedButton {
    [self.delegate pictureGridViewControllerDidFinished:self];
}

/// 点击预览按钮
- (void)clickPreviewButton {
    SYPicturePreviewViewController *preview = [[SYPicturePreviewViewController alloc] init];
    
    // 传递用户选中资源数组
    preview.selectedAssets = self.albumManager.selectedAssets;
    preview.selectedIndex = self.albumManager.selectedIndex;
    // 设置完成回调
    [preview setCompletedCallBack:^{
        [self clickFinishedButton];
    }];
    
    [self showViewController:preview sender:nil];
}

#pragma mark - FFPictureGridCellDelegate
- (void)pictureGridCell:(SYPictureGridCell *)cell didSelected:(BOOL)selected {
    
    // 判断是否已经到达最大数量
    if (self.albumManager.selectedAssets.count == self.maxPickerCount && selected) {
        
        NSString *message = [NSString stringWithFormat:@"最多只能选择 %zd 张照片", self.maxPickerCount];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
        [cell clickSelectedButton];
        
        return;
    }
    
    // 根据 selected 添加/删除用户选中的 asset
    if (selected) {
        [self.albumManager.selectedAssets addObject:cell.asset];
    } else {
        [self.albumManager.selectedAssets removeObject:cell.asset];
    }
    
    // 更新 UI 状态
    self.counterButton.count = self.albumManager.selectedAssets.count;
    self.doneItem.enabled = self.counterButton.count > 0;
    self.previewItem.enabled = self.counterButton.count > 0;
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumManager.cameraAlbum.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SYPictureGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSYGridCellId forIndexPath:indexPath];
    
    // 设置图像资源
    cell.asset = [self.albumManager.cameraAlbum assetWithIndex:indexPath.item];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SYPictureGridCell *cell = (SYPictureGridCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.isSelected) {
        // 设置选中索引
        self.albumManager.selectedIndex = [self.albumManager.selectedAssets indexOfObject:cell.asset];
        
        // 点击预览按钮
        [self clickPreviewButton];
    } else {
        NSLog(@"没有选中");
    }
}

#pragma mark - 设置界面
/// 准备 UI
- (void)prepareUI {
    // 1. 背景颜色
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 2. 设置导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseButton)];
    
    // 3. 设置工具栏
    self.previewItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(clickPreviewButton)];
    self.previewItem.enabled = NO;
    UIBarButtonItem *counterItem = [[UIBarButtonItem alloc] initWithCustomView:self.counterButton];
    self.doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickFinishedButton)];
    self.doneItem.enabled = NO;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[self.previewItem, spaceItem, counterItem, self.doneItem];
    
    // 4. 注册 collectioView 的可重用 cell
    [self.collectionView registerClass:[SYPictureGridCell class] forCellWithReuseIdentifier:kSYGridCellId];
}

#pragma mark - 懒加载控件
- (UIButton *)counterButton {
    if (_counterButton == nil) {
        _counterButton = [[SYCounterButton alloc] init];
    }
    return _counterButton;
}

@end
