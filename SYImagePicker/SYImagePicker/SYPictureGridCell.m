//
//  SYPictureGridCell.m
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import "SYPictureGridCell.h"

@interface SYPictureGridCell()
/// 图像视图
@property (nonatomic) UIImageView *imageView;
/// 选中按钮
@property (nonatomic) UIButton *selectedButton;
@end

@implementation SYPictureGridCell
#pragma mark - 设置数据
- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    
    // 加载照片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:self.bounds.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        self.imageView.image = result;
    }];
}

- (BOOL)isSelected {
    return self.selectedButton.selected;
}

#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    CGFloat offsetX = self.bounds.size.width - self.selectedButton.bounds.size.width;
    self.selectedButton.frame = CGRectOffset(self.selectedButton.bounds, offsetX, 0);
}

#pragma mark - 监听方法
/// 点击选中按钮
- (void)clickSelectedButton {
    self.selectedButton.selected = !self.selectedButton.selected;
    
    self.selectedButton.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.selectedButton.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         // 通知代理照片选中状态
                         [self.delegate pictureGridCell:self didSelected:self.selectedButton.selected];
                     }];
}

#pragma mark - 设置界面
/// 添加界面控件
- (void)prepareUI {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.selectedButton];
}

#pragma mark - 懒加载控件
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)selectedButton {
    if (_selectedButton == nil) {
        _selectedButton = [[UIButton alloc] init];
        
        [_selectedButton setImage:[UIImage imageNamed:@"compose_guide_check_box_default"] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageNamed:@"compose_guide_check_box_right"] forState:UIControlStateSelected];
        
        [_selectedButton sizeToFit];
        
        // 添加监听方法
        [_selectedButton addTarget:self action:@selector(clickSelectedButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}

@end
