//
//  SYCounterButton.m
//  SYImagePicker
//
//  Created by 申颖 on 16/3/12.
//  Copyright © 2016年 Ying. All rights reserved.
//

#import "SYCounterButton.h"

@implementation SYCounterButton

#pragma mark - 设置数据
- (void)setCount:(NSInteger)count {
    
    _count = count;
    
    [self setTitle:[NSString stringWithFormat:@"%zd", count] forState:UIControlStateNormal];
    BOOL isHidden = count <= 0;
    
    self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.hidden = isHidden;
                     } completion:nil];
}

#pragma 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

#pragma mark - 设置界面
- (void)prepareUI {
    [self setBackgroundImage:[UIImage imageNamed:@"compose_guide_number_icon"] forState:UIControlStateNormal];
    [self setTitle:@"0" forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.hidden = YES;
    
    [self sizeToFit];
    
    self.userInteractionEnabled = NO;
}


@end
