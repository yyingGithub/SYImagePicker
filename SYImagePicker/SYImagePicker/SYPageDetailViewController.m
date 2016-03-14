//
//  SYPageDetailViewController.m
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import "SYPageDetailViewController.h"
#import <Photos/Photos.h>

@interface SYPageDetailViewController ()
/// 滚动视图
@property (nonatomic) UIScrollView *scrollView;
/// 图像视图
@property (nonatomic) UIImageView *imageView;
@end

@implementation SYPageDetailViewController
#pragma mark - 设置数据
- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    
    // 照片请求选项
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 设置 resizeMode 可以按照指定大小缩放图像
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 设置 deliveryMode 为 HighQualityFormat 可以至回调一次缩放之后的照片，否则会调用多次
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    CGSize targetSize = self.view.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    targetSize = CGSizeMake(targetSize.width * scale, targetSize.height * scale);
    
    // 加载照片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        // 按照屏幕分辨率转换成当前设备需要的图片素材
        UIImage *image = [UIImage imageWithCGImage:result.CGImage scale:scale orientation:UIImageOrientationUp];
        
        [self setImagePosition:image];
    }];
}

/// 设置图像位置，如果是长图，顶端对齐，否则居中显示
///
/// @param image 图像
- (void)setImagePosition:(UIImage *)image {
    
    // 1. 计算图像显示大小
    CGSize size = [self dispalySize:image];
    self.imageView.image = image;
    
    // 2. 判断图像高度
    if (size.height > self.view.bounds.size.height) {
        self.imageView.frame = (CGRect) {CGPointZero, size};
        
        self.scrollView.contentSize = size;
    } else {
        self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
        
        CGFloat y = (self.view.bounds.size.height - size.height) * 0.5;
        self.scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
    }
}

/// 计算图像显示大小
///
/// @param image 要显示的图像
///
/// @return 以 ScrollView 宽度为基准的图像大小
- (CGSize)dispalySize:(UIImage *)image {
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = image.size.height * w / image.size.width;
    
    return CGSizeMake(w, h);
}

#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareUI];
}

#pragma mark - 设置界面
- (void)prepareUI {
    // 添加控件
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    // 自动布局
    self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_scrollView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDict]];
}

#pragma mark - 懒加载控件
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}


@end
