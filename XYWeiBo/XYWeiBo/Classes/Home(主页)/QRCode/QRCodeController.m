//
//  QRCodeController.m
//  QRCode
//
//  Created by mofeini on 16/9/28.
//  Copyright © 2016年 sey. All rights reserved.
//


#import "QRCodeController.h"
#import "UIImage+QRCode.h"
@implementation QRCodeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"二维码";

    //    UIImage *image = [UIImage qrImageByContent:@"www.baidu.com"];
    CGFloat width = 200;
    
    //    UIImage *image = [UIImage qrImageWithContent:@"www.baidu.com" size:width red:20 green:100 blue:100];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgView.frame = CGRectMake(20, 70, width, width);
    imgView.center = self.view.center;
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    imgView.layer.shadowOffset = CGSizeMake(1, 2);
    imgView.layer.shadowRadius = 1;
    imgView.layer.shadowOpacity = 0.5;
    [self.view addSubview:imgView];
    
    if (!_content) {
        _content = @"http://www.jianshu.com/p/66b1d9a9f448";
    }
    
    imgView.image = [UIImage qrImageWithContent:_content logo:[UIImage imageNamed:@"jay"] size:width red:20 green:100 blue:100];
}
@end
