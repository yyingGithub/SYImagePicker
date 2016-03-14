//
//  SYPicturePreviewViewController.m
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import "SYPicturePreviewViewController.h"
#import "SYPageDetailViewController.h"
#import "SYCounterButton.h"

@interface SYPicturePreviewViewController () <UIPageViewControllerDataSource>
/// 分页视图控制器
@property (nonatomic) UIPageViewController *pageController;
/// 完成按钮
@property (nonatomic) UIBarButtonItem *doneItem;
/// 选择计数按钮
@property (nonatomic) SYCounterButton *counterButton;
@end

@implementation SYPicturePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self prepareChildControllers];
}

- (void)dealloc {
    NSLog(@"%@ %s", self.class, __FUNCTION__);
}

#pragma mark - UIPageViewControllerDataSource
/// 返回左侧的视图控制器
///
/// @param pageViewController 分页控制器
/// @param viewController     当前显示的明细控制器
///
/// @return 左侧的视图控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self nextViewControllerWith:viewController isNext:NO];
}

/// 返回右侧的视图控制器
///
/// @param pageViewController 分页控制器
/// @param viewController     当前显示的明细控制器
///
/// @return 右侧的视图控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return [self nextViewControllerWith:viewController isNext:YES];
}

/// 返回当前控制器的下一个明细控制器
///
/// @param viewController 当前控制器
/// @param isNext         YES 返回右侧控制器 / NO 返回左侧控制器
///
/// @return 下一个明细控制器，如果越界返回 nil
- (SYPageDetailViewController *)nextViewControllerWith:(UIViewController *)viewController isNext:(BOOL)isNext {
    
    // 1. 获取索引
    NSInteger index = [(SYPageDetailViewController *)viewController index];
    
    // 2. 根据 isNext 计算索引值
    index += isNext ? 1 : -1;
    
    // 3. 判断是否越界
    if (index < 0 || index >= self.selectedAssets.count) {
        NSLog(@"要查找的索引是 %zd", index);
        return nil;
    }
    
    // 4. 实例化控制器
    SYPageDetailViewController *vc = [[SYPageDetailViewController alloc] init];
    vc.index = index;
    vc.asset = self.selectedAssets[index];
    
    return vc;
}

#pragma mark - 准备子控制器
/// 准备子控制器
- (void)prepareChildControllers {
    
    // 实例化分页控制器 - 水平分页滚动，页面间距 20
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey: @(20)};
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    // 实例化明细视图控制器
    SYPageDetailViewController *detail = [[SYPageDetailViewController alloc] init];
    // 设置初始索引
    detail.index = self.selectedIndex;
    detail.asset = self.selectedAssets[self.selectedIndex];
    
    // 创建视图控制器数组
    NSArray *viewControllers = @[detail];
    
    // 添加分页控制器的子视图控制器数组
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // 添加子控制器和子控制器视图
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    
    [self.pageController didMoveToParentViewController:self];
    
    // 设置手势 - Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageController.gestureRecognizers;
    
    // 设置数据源
    self.pageController.dataSource = self;
}

#pragma mark - 监听方法
/// 点击完成按钮
- (void)clickFinishedButton {
    if (self.completedCallBack != nil) {
        self.completedCallBack();
    }
}

#pragma mark - 设置界面
- (void)prepareUI {
    
    // 背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置工具栏
    UIBarButtonItem *counterItem = [[UIBarButtonItem alloc] initWithCustomView:self.counterButton];
    self.doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickFinishedButton)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[spaceItem, counterItem, self.doneItem];
    
    self.counterButton.count = self.selectedAssets.count;
}

#pragma mark - 懒加载控件
- (UIButton *)counterButton {
    if (_counterButton == nil) {
        _counterButton = [[SYCounterButton alloc] init];
    }
    return _counterButton;
}

@end
