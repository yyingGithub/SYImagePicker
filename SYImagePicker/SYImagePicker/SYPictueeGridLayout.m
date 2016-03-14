//
//  SYPictueeGridLayout.m
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import "SYPictueeGridLayout.h"
#pragma mark - 常量定义
/// 最小 Cell 宽高
static NSInteger kSYGridCellMinWH = 100;

@implementation SYPictueeGridLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger colCount = 3;
    CGSize size = self.collectionView.bounds.size;
    // 间距
    CGFloat margin = 5;
    // Cell 宽高
    CGFloat itemWH = [self itemWHWith:size count:colCount margin:margin];
    
    self.itemSize = CGSizeMake(itemWH, itemWH);
    self.minimumInteritemSpacing = margin;
    self.minimumLineSpacing = margin;
    self.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
}

- (CGFloat)itemWHWith:(CGSize)size count:(CGFloat)count margin:(CGFloat)margin {
    CGFloat itemWH = (size.width - (count + 1) * margin) / count;
    
    // 如果大于最小 cell 宽高就递归调用
    if (itemWH > kSYGridCellMinWH) {
        itemWH = [self itemWHWith:size count:count + 1 margin:margin];
    }
    
    return itemWH;
}

@end
