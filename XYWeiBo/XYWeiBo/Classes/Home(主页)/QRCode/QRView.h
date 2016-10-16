//
//  QRView.h
//  QRCode
//
//  Created by mofeini on 16/9/28.
//  Copyright © 2016年 sey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QRView;

@protocol QRViewDelegate <NSObject>
/**
 *  代理回调扫描结果
 *
 *  @param view   扫一扫视图
 *  @param result 扫描结果
 */
- (void)qrView:(QRView*)view ScanResult:(NSString*)result;

@end
@interface QRView : UIView

@property(nonatomic,assign)id<QRViewDelegate> delegate;

@property(nonatomic,assign,readonly)CGRect scanViewFrame;

- (void)startScan;
- (void)stopScan;
@end
