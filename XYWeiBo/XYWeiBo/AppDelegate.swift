//
//  AppDelegate.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/27.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var rootViewController : UIViewController {
        
        let isLogin = XYUserAccountViewModel.shareInstance.isLogin
     
        // 当用户已经登录时就设置rootViewController为欢迎界面，如果没有登录就设置rootViewController为主界面
        return isLogin ? XYWelocmeViewController() : UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 设置全局tabBar的前景颜色
        UITabBar.appearance().tintColor = UIColor.orange
        // 设置导航条全局的前景颜色
        UINavigationBar.appearance().tintColor = UIColor.orange
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        // 打开数据库
        SQLiteManager.sharedInstance.openDB(dbName: "status.sqlite")
        
        //print(XYUserAccountViewModel.shareInstance.userAccount?.access_token)
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // 应用程序进入后台时，清除三天前本地缓存的微博数据
        SQLiteManager.sharedInstance.clearStatusData(howMuchDaysAgo: 3)
    }
}

