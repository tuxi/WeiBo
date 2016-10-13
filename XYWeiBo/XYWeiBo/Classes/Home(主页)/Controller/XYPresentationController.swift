//
//  XYPresentationController.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/29.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYPresentationController: UIPresentationController {

    // MARK:- 属性
    lazy var coverView : UIView = UIView()
    var presentedViewFrame = CGRect.zero
    
    
    // modal出来的控制器的view是被添加到containerView(容器视图)里面了，所以要想修改modal出来控制器view的尺寸可以从containerView中拿到弹出的控制器的view，修改弹出控制器的view的frame
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 改变即将弹出的view的尺寸
        // 1.从containerView中拿到弹出的控制器的view，修改弹出控制器的view的frame
        presentedView?.frame = presentedViewFrame
        
        // 2.添加蒙版
        setupCoverView()
        
    }
}

// MARK:- 设置UI相关界面
extension XYPresentationController {

    func setupCoverView() {
        
        // 1.添加蒙版到容器视图上
        containerView?.insertSubview(coverView, at: 0)
        
        // 2.设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.3)
        coverView.frame = containerView!.bounds
        
        // 3.给蒙版添加手势
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverViewClick)))
        
    }
}

// MARK:- 事件监听
extension XYPresentationController {
    
    func coverViewClick() {
        
        // 退出弹出的控制器: presentedViewController是已经弹出的控制器
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

