//
//  XYBaseViewController.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/28.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYBaseViewController: UITableViewController {

    // MARK:- 懒加载
    lazy var visitorView : XYVisitorView = XYVisitorView.visitorView()
    
    // 根据沙盒中取出用户的信息，判断用户是否已经登录
    var isLogin = XYUserAccountViewModel.shareInstance.isLogin
    
   // MARK:- 控制器view的声明周期
    override func loadView() {
        
        // 根据用户登录状态，确定要加载的view
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        // 添加导航条上的item
        addNavigationBarItem()
    }
    
    // MARK:- 自定义的函数
    func setupVisitorView() {
        // 设置访客视图成为控制器的view
        view = visitorView
        // 给访客视图中的【注册】和【登录】按钮添加点击事件
        visitorView.registerButton.addTarget(self, action: #selector(registerBarButtonItemClick), for: .touchUpInside)
        visitorView.loginButton.addTarget(self, action: #selector(loginBarButtonItemClick), for: .touchUpInside)
    
    }
   
    /// 在导航条上添加【注册】和【登录】按钮
    func addNavigationBarItem() {
        
        // 左侧按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self, action: #selector(registerBarButtonItemClick))
        // 右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", style: .plain, target: self, action: #selector(loginBarButtonItemClick))
    }

}

// MARK:- 事件处理
extension XYBaseViewController {

    /// 监听注册按钮的点击事件
    func registerBarButtonItemClick() {
        print("点击了注册按钮")
    }
    
    /// 监听登录按钮的点击事件
    func loginBarButtonItemClick() {
        
        // 创建OAuthVc
        let OAuthVc = XYOAuthViewController()
        
        // 包装为导航控制器
        let nav = UINavigationController.init(rootViewController: OAuthVc)
        
        // 弹出控制器
        self.present(nav, animated: true, completion: nil)
    }
}
