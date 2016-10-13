//
//  UIBarButtonItem-Extension.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/28.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    /// 快速创建一个自定义的UIBarButtonItem
    /* 第一种方法
    convenience init(imageName: String) {
        self.init()
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        button.sizeToFit()
        
        self.customView = button
    }
    */
    /// 快速创建一个自定义的UIBarButtonItem
    convenience init(imageName: String) {
     
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        button.sizeToFit()
        
        self.init(customView: button)
    }
}
