//
//  XYTitleButton.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/28.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYTitleButton: UIButton {

    // MARK:- 重写init函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()

    }
    
    // swift中只要重写了控件的init(frame :)或init方法，就必须重写以下方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 重写layoutSubviews函数
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 跳转按钮中imageView和label的位置
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
    }

}
