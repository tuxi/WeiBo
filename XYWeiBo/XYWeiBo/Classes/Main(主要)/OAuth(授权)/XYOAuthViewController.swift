//
//  XYOAuthViewController.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/29.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit
import SVProgressHUD

class XYOAuthViewController: UIViewController {

    // MARK:- 属性
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置导航条内容
        setupNavigationBarItem()
        
        // 2.加载登录界面
        loadPage()
        
    }
    
    func loadPage() {
        
        //App Key：2073246685
        //App Secret：b95fa57b1197c1ce4c7e67914e10a5ef
        // 1.获取url路径
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        // 2.创建对应的URL
        guard let url = URL(string: urlString) else {
            return
        }
    
        // 3.创建请求对象
        let request = URLRequest(url: url)
        
        // 4.加载登录网页
        webView.loadRequest(request)
        
        // 5.设置webView的代理
        webView.delegate = self
        
    }

 

}

// MARK:- 设置UI界面相关
extension XYOAuthViewController {

    /// 设置导航条内容
    func setupNavigationBarItem() {
        
        // 1.左侧
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(closedBarButtonItemClick))
        
        // 2.右侧
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "填充", style: .plain, target: self, action: #selector(fillBarButtonItemClick))
        
        // 3.标题视图
        title = "登录页面"
    }
}

// MARK:- 事件监听
extension XYOAuthViewController {

    /// 关闭按钮的点击事件
    func closedBarButtonItemClick() {
        
        dismiss(animated: true, completion: nil)
    }
    
    /// 填充按钮的点击事件:将账号和密码填充到账号和密码输入框
    func fillBarButtonItemClick() {
        
        // 1.书写js代码javaScript
        let jsCode = "document.getElementById('userId').value='weiboAccount';document.getElementById('passwd').value='weiboPassword';"
        // 2.执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }

}

// MARK:- UIWebViewDelegate
extension XYOAuthViewController : UIWebViewDelegate {
    
    /// 开始加载网页的时候调用
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.show(withStatus: "正在加载中...")
    }
    
    /// 加载完成的时候调用
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    /// 加载网页失败的时候调用
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    /// 当准备加载某个网页时调用这个方法
    // 返回true时继续加载网页，返回false时不会加载该网页
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.获取当前正在加载的网页url
        guard let url = request.url else {
            return true
        }
        
        // 2.将url转换为字符串
        let urlString = url.absoluteString
        
        // 3.判断字符串中是否包含code=,如果包含就继续
        guard urlString.contains("code=") else {
            return true
        }
        
        // 4.裁剪字符串，只要code=后面的字符
        // 这个方法会code=前面和后面的字段放在数组中返回，所以我们只要后面的
        let code = urlString.components(separatedBy: "code=").last!
        
        // 5.获取AccessToken
        XYNetworkTools.shareInstace.loadAccessToken(code: code) { (result, error) in
            
            // 5.1错误校验，如果有错误直接返回
            if error != nil {
                print(error)
                return
            }
            
            // 5.2拿到结果
            guard let accountDict = result else {
                print("没有拿到授权的票据")
                return
            }
            // 5.3字典模型
            let account = XYUserAccount(dict: accountDict)
            
            // 5.3请求用户个人信息
            self.loadUserInfo(userAccount: account)
        }
        
        return false
    }
    
    private func loadUserInfo(userAccount: XYUserAccount) {
        
        // 1.access_token 
        guard let access_token = userAccount.access_token else {
            return
        }
        
        // 2.uid
        guard let uid = userAccount.uid else {
            return
        }
        
        // 3.请求用户个人信息
        XYNetworkTools.shareInstace.loadUserInfo(access_token: access_token, uid: uid) { (result, error) in
            
            // 3.1判断是否有错误，如果有错误就返回
            if error != nil {
                return
            }
            
            // 3.2拿到服务器返回的结果
            guard let userInfo = result else {
                return
            }
            
            // 3.2从服务器返回的数据中找到需要的属性avatar_large(头像url)、screen_name(昵称)添加到UserAccount模型中
            // 将其转换为模型
            userAccount.avatar_large = userInfo["avatar_large"] as? String // 字典中取出的是Any类型，所以需要转换为String
            userAccount.screen_name = userInfo["screen_name"] as? String
            
            // 4.将用户信息保存到沙盒documentDirectory
            // 保存对象：将userAccount对象保存到documentPath路径下
            NSKeyedArchiver.archiveRootObject(userAccount, toFile: XYUserAccountViewModel.shareInstance.accountPath)
            
            // 5.将userAccount赋值
            XYUserAccountViewModel.shareInstance.userAccount = userAccount
            
            // 6.dissmss当前控制器
            self.dismiss(animated: false, completion: { 
                // 6.1显示欢迎界面，并将欢迎界面设置为窗口的根控制器
                UIApplication.shared.keyWindow?.rootViewController = XYWelocmeViewController()
            })
            
        }
    }
}

