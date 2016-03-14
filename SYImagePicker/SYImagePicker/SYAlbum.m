//
//  SYAlbum.m
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import "SYAlbum.h"
@interface SYAlbum()
/// 资源集合
@property (nonatomic) PHAssetCollection *collection;
/// 当前相册内的资源查询结果 - 所有照片/视频
@property (nonatomic) PHFetchResult *assetFetchResult;
@end

@implementation SYAlbum
#pragma mark - 只读属性
- (NSString *)title {
    return self.collection.localizedTitle;
}

- (NSInteger)count {
    return self.assetFetchResult.count;
}

- (PHAsset *)assetWithIndex:(NSInteger)index; {
    return [self.assetFetchResult objectAtIndex:index];
}

#pragma mark - 构造函数
+ (instancetype)albumWithCollection:(PHAssetCollection *)collection {
    return [[self alloc] initWithCollection:collection];
}

- (instancetype)initWithCollection:(PHAssetCollection *)collection {
    self = [super init];
    if (self) {
        _collection = collection;
        
        // 设置查询选项
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        // 仅搜索照片
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
        // 按照创建日期降序排列照片
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        // 从 collection 中查询资源结果
        _assetFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    }
    return self;
}

@end
