//
//  SYPictureGridCell.h
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol SYPictureGridCellDelegate;
@interface SYPictureGridCell : UICollectionViewCell
/// 图片资源
@property (nonatomic) PHAsset *asset;
/// 照片 Cell 代理
@property (nonatomic, weak) id<SYPictureGridCellDelegate> delegate;
/// 是否选中状态
@property (nonatomic, readonly) BOOL isSelected;
/// 点击选中按钮
- (void)clickSelectedButton;
@end

#pragma mark - 照片 cell 协议
@protocol SYPictureGridCellDelegate <NSObject>

/// 照片 cell 选中照片
///
/// @param cell     照片 cell
/// @param selected 是否选中
- (void)pictureGridCell:(SYPictureGridCell *)cell didSelected:(BOOL)selected;

@end
