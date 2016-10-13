//
//  XYComposeTitleView.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/2.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit


class XYComposeTitleView: UIView {
    
    class func titleViewFromNib() -> XYComposeTitleView {
        
        return Bundle.main.loadNibNamed("XYComposeTitleView", owner: nil, options: nil)?.first as! XYComposeTitleView
    }
    
    // MARK:- 属性
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    
    
    // MARK:- 系统回调
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        screenNameLabel.textColor = UIColor.lightGray
        
        // 4.设置文字内容
        titleLabel.text = "发微博"
        screenNameLabel.text = XYUserAccountViewModel.shareInstance.userAccount?.screen_name
    
    }

//    // MARK:- 懒加载属性
//    lazy var titleLabel : UILabel = UILabel()
//    lazy var screeenNameLabel : UILabel = UILabel()
//    
//    // MARK:- 系统回调函数
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubview(titleLabel)
////        addSubview(screeenNameLabel)
//        
//        
//        setupUI()
//        
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

}

// MARK:- 设置UI界面
extension XYComposeTitleView {

    func setupUI() {
        
        // 禁止AutoResizing自动转换为约束
//        self.translatesAutoresizingMaskIntoConstraints = false
//        
//        // 设置约束
//        // titleLabel中心点X的约束
//        let titleLabelCenterX = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
//        self.addConstraint(titleLabelCenterX)
//        
//        // titleLabel顶部约束
//        let titleLabelTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
//        self.addConstraint(titleLabelTop)
//        let titleLabelWidth = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
//        self.addConstraint(titleLabelWidth)
//        let titleLabelHeight = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
//        self.addConstraint(titleLabelHeight)
        
        // screeenNameLabel中心点X的约束
//        let screeenNameLabelCenterX = NSLayoutConstraint(item: screeenNameLabel, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1.0, constant: 0)
//        self.addConstraint(screeenNameLabelCenterX)
//        
//        // screeenNameLabel顶部约束
//        let screeenNameLabelTop = NSLayoutConstraint(item: screeenNameLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: -3)
//        self.addConstraint(screeenNameLabelTop)
        
        // 3.设置空间的属性
//        titleLabel.font = UIFont.systemFont(ofSize: 16)
//        screeenNameLabel.font = UIFont.systemFont(ofSize: 14)
//        
//        screeenNameLabel.textColor = UIColor.lightGray
//        
//        // 4.设置文字内容
//        titleLabel.text = "发微博"
//        screeenNameLabel.text = XYUserAccountViewModel.shareInstance.userAccount?.screen_name
        
    }
}
