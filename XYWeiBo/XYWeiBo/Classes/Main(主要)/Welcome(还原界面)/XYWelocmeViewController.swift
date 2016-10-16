//
//  XYWelocmeViewController.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/30.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit
import SDWebImage

class XYWelocmeViewController: UIViewController {

    /// 头像控件
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var profileViewBottomConstr: NSLayoutConstraint!
    
    @IBOutlet weak var welecomeLabel: UILabel!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.加载头像
        let profileUrlString = XYUserAccountViewModel.shareInstance.userAccount?.avatar_large

        let profileUrl = URL(string: profileUrlString ?? "")
        profileView.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "avatar_default_big"))
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 2.0修改头像的底部约束
        profileViewBottomConstr.constant = UIScreen.main.bounds.size.height - 150
        
        // 2.1更新frame
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .allowAnimatedContent, animations: {
            
            self.view.layoutIfNeeded()
            
        }) {(isCompeltion) in
            
            // 动画执行完毕后进入主界面
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
            
        }
    }


}
