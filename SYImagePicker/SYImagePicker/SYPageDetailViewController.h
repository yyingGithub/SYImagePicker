//
//  SYPageDetailViewController.h
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;

@interface SYPageDetailViewController : UIViewController
/// 图像索引
@property (nonatomic) NSInteger index;
/// 图片资源
@property (nonatomic) PHAsset *asset;

@end
