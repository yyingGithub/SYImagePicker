//
//  ViewController.m
//  SYImagePicker
//
//  Created by 申颖 on 15/12/19.
//  Copyright © 2015年 Ying. All rights reserved.
//

#import "ViewController.h"
#import "SYImagePickerController.h"

@interface ViewController ()<SYImagePickerControllerDelegate>
@property (nonatomic) NSArray *pictures;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - FFImagePickerControllerDelegate
- (void)imagePickerController:(SYImagePickerController *)picker didFinishSelectedPictures:(NSArray<UIImage *> *)pictures {
    NSLog(@"%@", pictures);
    self.pictures = pictures;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickButton:(id)sender {
    
    SYImagePickerController *picker = [[SYImagePickerController alloc] init];
    picker.pickerDelegate = self;
    picker.targetSize = CGSizeMake(500, 500);
    picker.maxPickerCount = 5;
    
    [self presentViewController:picker animated:YES completion:nil];
}

@end
