//
//  XYComposeTextView.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/2.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYComposeTextView: UITextView {

    // MARK:- 懒加载
    lazy var placeHodlerLabel : UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }

}

// MARK:- 设置UI界面
extension XYComposeTextView {
    
    func setupUI() {
        
        self.tintColor = UIColor.orange
        
        addSubview(placeHodlerLabel)
        
        // 设置frame
        placeHodlerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // placeHodlerLabel的顶部约束
        let topConstr = NSLayoutConstraint(item: placeHodlerLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 8)
        self.addConstraint(topConstr)
        
        // placeHodlerLabel的最侧约束
        let leftConstr = NSLayoutConstraint(item: placeHodlerLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 10)
        self.addConstraint(leftConstr)
        
        // 3.设置placeholderLabel属性
        placeHodlerLabel.textColor = UIColor.lightGray
        placeHodlerLabel.font = font
        
        // 4.设置placeholderLabel文字
        placeHodlerLabel.text = "分享新鲜事..."
        
        // 5.设置内容的内边距
        self.textContainerInset = UIEdgeInsets(top: 8, left: 6, bottom: 0, right: 6)

    }
    
}
