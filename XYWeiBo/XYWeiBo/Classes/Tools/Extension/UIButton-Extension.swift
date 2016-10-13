//
//  UIButton-Extension.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/28.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

extension UIButton {

    // swift中类方法以class开始，类似于oc中的+开头的方法
    class func creatButton(_ imageName: String, backGroundImageName: String) -> UIButton {
    
        // 创建按钮
        let button = UIButton()
        
        // 设置按钮的属性
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        button.setBackgroundImage(UIImage(named: backGroundImageName), for: .normal)
        button.setBackgroundImage(UIImage(named: backGroundImageName + "_highlighted"), for: .highlighted)
        button.sizeToFit()
        return button
    }
    
    // 便利构造函数
    // convenience : 便利,使用convenience修饰的构造函数叫做便利构造函数
    // 遍历构造函数通常用在对系统的类进行构造函数的扩充时使用
    /*
     遍历构造函数的特点
     1.遍历构造函数通常都是写在extension里面
     2.遍历构造函数init前面需要加载convenience
     3.在遍历构造函数中需要明确的调用self.init()
     */

    convenience init(imageName: String, backGroundImageName: String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: backGroundImageName), for: .normal)
        setBackgroundImage(UIImage(named: backGroundImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(title: String, bgColor: UIColor, font: UIFont) {
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = font
    }
    
}
