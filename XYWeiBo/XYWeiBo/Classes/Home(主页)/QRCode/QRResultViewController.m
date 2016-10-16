//
//  QRResultViewController.m
//  XYWeiBo
//
//  Created by mofeini on 16/10/17.
//  Copyright © 2016年 sey. All rights reserved.
//

#import "QRResultViewController.h"

@interface QRResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation QRResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textLabel.text = self.qrCodeText;
}




@end
