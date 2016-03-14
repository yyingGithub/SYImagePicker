//
//  SYPictureGridViewController.h
//  SYImagePicker
//
//  Created by 申颖 on 15/12/19.
//  Copyright © 2015年 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYAlbumManager;
@protocol SYPictureGridViewControllerDelegate;

#pragma mark - 照片网格选择控制器
@interface SYPictureGridViewController : UICollectionViewController
/// 照片选择代理
@property (nonatomic, weak) id<SYPictureGridViewControllerDelegate> delegate;
/// 相册管理器
@property (nonatomic) SYAlbumManager *albumManager;
/// 最大选择照片数量，默认 9 张
@property (nonatomic) NSInteger maxPickerCount;
@end

#pragma mark - 照片网格选择控制器协议

@protocol SYPictureGridViewControllerDelegate <NSObject>

/// 选择照片完成
- (void)pictureGridViewControllerDidFinished:(SYPictureGridViewController *)controller;

@end
