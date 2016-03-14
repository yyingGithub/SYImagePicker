//
//  SYImagePickerController.h
//  SYImagePicker
//
//  Created by 申颖 on 15/12/19.
//  Copyright © 2015年 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYImagePickerControllerDelegate;

//照片选择控制器
@interface SYImagePickerController : UINavigationController
/// 照片选择代理
@property (nonatomic, weak) id<SYImagePickerControllerDelegate> pickerDelegate;
/// 加载图像尺寸(以像素为单位，默认大小 600 * 600)
@property (nonatomic) CGSize targetSize;
/// 最大选择照片数量，默认 9 张
@property (nonatomic) NSInteger maxPickerCount;

@end

#pragma mark - 照片选择控制器协议
@protocol SYImagePickerControllerDelegate <NSObject>

@optional
/// 照片选择完成代理方法
///
/// @param picker   照片选择控制器
/// @param pictures 用户选中照片数组
- (void)imagePickerController:(SYImagePickerController *)picker didFinishSelectedPictures:(NSArray <UIImage *> *)pictures;

@end

