//
//  SYPicturePreviewViewController.h
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;

#pragma mark - 照片预览控制器
@interface SYPicturePreviewViewController : UIViewController
/// 用户选中资源列表
@property (nonatomic) NSMutableArray <PHAsset *> *selectedAssets;
/// 当前选中照片索引
@property (nonatomic) NSInteger selectedIndex;
/// 完成回调
@property (nonatomic, copy) void (^completedCallBack)();

@end
