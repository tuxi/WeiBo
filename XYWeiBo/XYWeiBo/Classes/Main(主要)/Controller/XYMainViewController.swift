//
//  XYMainViewController.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/27.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

// 类的命名空间 <XYWeiBo.XYHomeViewController>
class XYMainViewController: UITabBarController {

    // MARK:- 懒加载
    // 图片的名称数组，方便设置item的图片的,在第二位插入空白的字符串，方便拼配item的图片时，第二个不需要设置，不影响后面的索引
    lazy var imageNames = ["tabbar_home", "tabbar_message_center", "", "tabbar_discover", "tabbar_profile"]
    
    // 加号按钮
    // 调用类函数设置
    //lazy var composeBtn : UIButton = UIButton.creatButton(imageName: "tabbar_compose_icon_add", backGroundImageName: "tabbar_compose_button")
    // 调用便利构造函数设置
    lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", backGroundImageName: "tabbar_compose_button")
    
    // MARK:- 控制器的声明周期
    // 控制器的view加载完成的时候调用
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupComposeBtn()
    }
    
    // 控制器的view即将显示的时候调用
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupAlltabBarItems()
    }

}

// MARK:- 设置UI相关界面
extension XYMainViewController {

    /// 设置发布按钮
    func setupComposeBtn() {

        // 1.添加加号按钮到tabBar
        tabBar.addSubview(composeBtn)
        // 2.设置加号按钮的位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        // 3.给加号按钮添加点击事件
        // 事件监听的本质，就是发送消息，但是发送消息是OC的特性
        // 发送消息的过程:将方法包装成@SEL --> 去类中查找方法列表 --> 根据@SEL查找imp指针(函数指针) --> 执行函数
        // 如果swift中将一个函数声明成private，那么该函数不会添加到方法列表中，
        // 如果在该函数前面加上@objc， 那么该函数依旧会被添加到方法列表中
        // selctor的包装方式:1.#selector(方法名称) 2.#selector(类名.方法名称)
        composeBtn.addTarget(self, action: #selector(XYMainViewController.composeBtnClick), for: .touchUpInside)
    }

    
    /// 调整tabBar的item的属性
    func setupAlltabBarItems() {
    
        // 1.遍历所有的item
        for i in 0..<tabBar.items!.count {
            // 由于storyboard中肯定有tabBar的item所以可以强制解包
            let item = tabBar.items![i]
            
            // 2.判断如果是第二个item就跳过，并且设置enable禁止
            if i == 2 {
                item.isEnabled = false
                continue
            }
            
            // 3.设置item的选中图片
            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")

        }
    }
}

// MARK:- 监听事件点击
extension XYMainViewController {
    
    /// 点击tabBar上发布按钮的点击事件
    func composeBtnClick() {
        
        let composeVc = XYComposeViewController()
        let composeNav = XYNavigationController(rootViewController: composeVc)
        
        present(composeNav, animated: true, completion: nil)

    }
    

}


