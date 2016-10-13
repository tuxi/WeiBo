//
//  XYVisitorView.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/28.
//  Copyright © 2016年 sey. All rights reserved.
//  访客视图

import UIKit

class XYVisitorView: UIView {

    class func visitorView() -> XYVisitorView {
        return Bundle.main.loadNibNamed("XYVisitorView", owner: nil, options: nil)?.first as! XYVisitorView
    
    }
    
    // MARK:- 属性
    // 转盘
    @IBOutlet weak var rotationView: UIImageView!
    // logo
    @IBOutlet weak var logoView: UIImageView!
    // 文字描述
    @IBOutlet weak var tipLabel: UILabel!
    // 注册按钮
    @IBOutlet weak var registerButton: UIButton!
    // 登录按钮
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK:- 自定义的函数
    /// 设置访客视图界面的属性
    func setupVisitorViewInfo(_ logoImageName: String, tipTitle: String) {
        
        logoView.image = UIImage(named: logoImageName)
        tipLabel.text = tipTitle
        // 隐藏转盘(只有home界面不会调这个方法，因为这个xib就是按钮home界面搭建的，只需要修改其他几个界面即可)
        rotationView.isHidden = true
    }
    
    /// 给转盘添加旋转动画
    func rotationAnim() {
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画属性
        rotationAnim.fromValue = 0 // 动画开始的位置
        rotationAnim.toValue = M_PI * 2 // 动画结束的位置(360°)
        rotationAnim.repeatCount = MAXFLOAT // 动画执行的次数
        rotationAnim.duration = 8 // 执行一次动画需要的时间(这里设置的一次为360)
        rotationAnim.isRemovedOnCompletion = false // 动画所在的view消失时，不会移除核心动画 动画完成后是否移除
        
        // 给转盘添加核心动画
        rotationView.layer.add(rotationAnim, forKey: nil)
        
    }
}
