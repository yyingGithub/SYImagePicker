//
//  SYImagePickerController.m
//  SYImagePicker
//
//  Created by 申颖 on 15/12/19.
//  Copyright © 2015年 Ying. All rights reserved.
//

#import "SYImagePickerController.h"
#import "SYPictureGridViewController.h"
#import "SYAlbumManager.h"


//私有扩展中，定义属性
@interface SYImagePickerController ()<SYPictureGridViewControllerDelegate>
//根视图控制器
@property (nonatomic) SYPictureGridViewController *rootViewController;
@end

@implementation SYImagePickerController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}

#pragma mark - getter & setter 属性
- (CGSize)targetSize {
    if (CGSizeEqualToSize(_targetSize, CGSizeZero)) {
        // 如果没有设置 targetSize，设置默认大小
        _targetSize = CGSizeMake(600, 600);
    }
    return _targetSize;
}

- (void)setMaxPickerCount:(NSInteger)maxPickerCount {
    _maxPickerCount = maxPickerCount;
    
    self.rootViewController.maxPickerCount =_maxPickerCount;
}

#pragma mark - FFPictureGridViewControllerDelegate
- (void)pictureGridViewControllerDidFinished:(SYPictureGridViewController *)controller {
    
    // 判断代理是否实现协议方法
    if (![self.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishSelectedPictures:)]) {
        // 如果没有实现协议方法，直接关闭控制器并且返回
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    // 异步加载图像
    [self requestImages:controller.albumManager.selectedAssets completed:^(NSArray<UIImage *> *pictures) {
        
        // 通知代理用户选中照片
        [self.pickerDelegate imagePickerController:self didFinishSelectedPictures:pictures];
    }];
}

/// 根据 PHAsset 数组，统一查询用户选中照片
///
/// @param selectedAssets 用户选中 PHAsset 数组
/// @param completed      完成回调，缩放后的照片数组在回调参数中
- (void)requestImages:(NSMutableArray <PHAsset *> *)selectedAssets completed:(void (^)(NSArray <UIImage *> *pictures))completed {
    // 照片请求选项
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 设置 resizeMode 可以按照指定大小缩放图像
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 设置 deliveryMode 为 HighQualityFormat 可以至回调一次缩放之后的照片，否则会调用多次
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    // 设置加载图像尺寸(以像素为单位)
    CGSize targetSize = self.targetSize;
    
    // 创建照片数组
    NSMutableArray <UIImage *> *pictures = [NSMutableArray array];
    
    // 创建调度组
    dispatch_group_t group = dispatch_group_create();
    for (PHAsset *asset in selectedAssets) {
        
        // 入组
        dispatch_group_enter(group);
        
        // 异步请求图像
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            // 记录查询结果
            [pictures addObject:result];
            
            // 出组
            dispatch_group_leave(group);
        }];
    }
    
    // 等待加载完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completed(pictures.copy);
    });
}

#pragma mark - 构造函数
- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置根控制器
        _rootViewController = [[SYPictureGridViewController alloc] init];
        _rootViewController.delegate = self;
        
        [self pushViewController:_rootViewController animated:YES];
        
        // 设置默认最大选择照片数量
        self.maxPickerCount = 9;
        
        // 显示工具栏
        self.toolbarHidden = NO;
    }
    return self;
}


@end
