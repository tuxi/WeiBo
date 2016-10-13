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

    // MARK:- 拖线属性
    /// 头像底部距离控制器view底部之间约束
//    @IBOutlet weak var profileViewBottomConstr: NSLayoutConstraint!
    /// 头像控件
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // 1.加载头像
        let profileUrlString = XYUserAccountViewModel.shareInstance.userAccount?.avatar_large
        // ?? : 如果??前面的可选类型有值，就解包并赋值，如果??前面的可选类型没有值，就使用??后面的值赋值
        let profileUrl = URL(string: profileUrlString ?? "")
        profileView.sd_setImage(with: profileUrl, placeholderImage: UIImage(named: "avatar_default_big"))
 
        // 2.修改约束
        
//        profileViewBottomConstr.constant = (UIScreen.main.bounds.size.height - 200)
        
        
        // 2.1更新约束
        // delay: 延迟执行动画的时间
        // usingSpringWithDamping:阻力系数，助力越大弹跳效果越不明显，取值范围为0~1
        // initialSpringVelocity: 初始化的速度
        // 注意:swift中如果枚举不想传值，可以直接传[]，如果需要传多个枚举值，可以写在[]中
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .allowAnimatedContent, animations: {
        
//            self.view.layoutIfNeeded()
            self.contentView.frame.origin.y = 500;
            
            }) {(isCompeltion) in
        
                // 动画执行完毕后进入主界面
                UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        
        }
    }


}
