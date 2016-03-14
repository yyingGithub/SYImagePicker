//
//  SYAlbumManager.h
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYAlbum.h"

/// 相册管理器模型 - 管理相册列表和用户授权
@interface SYAlbumManager : NSObject
/// 构造函数 - 实例化相册管理器并且加载相册列表
///
/// @param completed 完成回调 - 返回相册标题，通过完成回调可以刷新数据
///
/// @return 相册管理器模型
- (instancetype)initWithCompleted:(void (^)(NSString *title))completed;

/// 相机胶卷相册
@property (nonatomic) SYAlbum *cameraAlbum;

/// 用户选中资源列表
@property (nonatomic) NSMutableArray <PHAsset *> *selectedAssets;
/// 当前选中照片索引
@property (nonatomic) NSInteger selectedIndex;

@end
