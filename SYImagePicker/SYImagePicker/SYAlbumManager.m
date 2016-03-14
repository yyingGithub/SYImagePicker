//
//  SYAlbumManager.m
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import "SYAlbumManager.h"
#import <Photos/Photos.h>

@interface SYAlbumManager() <PHPhotoLibraryChangeObserver>
/// 相册集合
@property (nonatomic) PHFetchResult *albumFetchResult;
/// 查询相册完成回调
@property (nonatomic, copy) void (^completedCallBack)(NSString *);
@end

@implementation SYAlbumManager

#pragma mark - 构造函数
- (instancetype)initWithCompleted:(void (^)(NSString *title))completed {
    self = [super init];
    if (self) {
        // 断言完成回调
        NSAssert(completed != nil, @"必须传入完成回调");
        
        // 记录完成回调
        _completedCallBack = completed;
        
        // 加载相册列表细节
        [self loadAlbumListDetail];
        
        // 注册相册访问权限变化观察者
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    return self;
}

/// 加载相册列表细节
- (void)loadAlbumListDetail {
    
    // 提示：由于 fetchAssetCollectionsWithType 方法获取的相册数量可能不止一个
    // 如果需要获取到`相机胶卷`，需要遍历查询结果才能够拿到
    [self.albumFetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
        
        // 判断集合类型
        if (obj.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            
            // 设置相机胶卷相册
            self.cameraAlbum = [SYAlbum albumWithCollection:obj];
        }
    }];
    
    // 执行完成回调
    self.completedCallBack(self.cameraAlbum.title);
}

- (void)dealloc {
    // 删除观察者
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - PHPhotoLibraryChangeObserver
/// 访问照片权限变化监听方法
///
/// @param changeInstance 变化实例
/// 注意：Photos 框架会在其他队列调用此方法。如果需要更新 UI，需要在主队列调度后续任务
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
    // 查找明细信息变化
    PHFetchResultChangeDetails *detail = [changeInstance changeDetailsForFetchResult:self.albumFetchResult];
    
    // 判断是否有变化
    if (detail == nil) {
        return;
    }
    
    // 重新记录变化结果
    self.albumFetchResult = detail.fetchResultAfterChanges;
    
    // 加载变化后的相册列表细节
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadAlbumListDetail];
    });
}

#pragma mark - 懒加载属性
- (PHFetchResult *)albumFetchResult {
    if (_albumFetchResult == nil) {
        _albumFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    }
    return _albumFetchResult;
}

- (NSMutableArray *)selectedAssets {
    if (_selectedAssets == nil) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

@end
