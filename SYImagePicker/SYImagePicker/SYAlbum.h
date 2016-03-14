//
//  SYAlbum.h
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface SYAlbum : NSObject

/// 使用资源集合实例化相册
- (instancetype)initWithCollection:(PHAssetCollection *)collection;
+ (instancetype)albumWithCollection:(PHAssetCollection *)collection;

/// 相册标题
@property (nonatomic, readonly) NSString *title;
/// 相册照片数量
@property (nonatomic, readonly) NSInteger count;

/// 返回指定索引的资源对象
- (PHAsset *)assetWithIndex:(NSInteger)index;

@end
