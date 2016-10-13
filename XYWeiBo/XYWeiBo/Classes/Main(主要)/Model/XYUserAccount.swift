//
//  XYUserAccount.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/30.
//  Copyright © 2016年 sey. All rights reserved.
//  用户微博账号模型类

import UIKit

class XYUserAccount: NSObject, NSCoding {

    // MARK:- 属性
    /******************* begin-服务器返回的属性 ************************/
    // 用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    var access_token : String?
    // 授权用户的UID
    var uid : String?
    
    // access_token的生命周期，单位是秒数,过期日期
    // 由于秒数不方便查看，需要转换为NSDate的格式: --> 方法:通过属性监听器，监听expires_in属性只要发送了变化就将其转换为NSDate，我们需要声明一个NSDate的类型的变量，将转换后的值赋值给声明的这个变量
    var expires_in : TimeInterval = 0.0 {
        didSet { // 当expires_in变量的值发送改变时就会调用
            // 将expires_in转换为从现在开始的时间
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    // 头像url
    var avatar_large : String?
    // 昵称
    var screen_name : String?
    
    /******************* end-服务器返回的属性 ************************/
    
    /******** begin-非服务器返回的数据，仅仅为了增加开发效率定义的变量 *********/
    var expires_date : Date?
    
    /******** end-非服务器返回的数据 *********/
    
    // MARK:- 构造函数
    init(dict: [String : Any]) {
        super.init()
        
        // KVC字典转模型
        setValuesForKeys(dict)
    }
    
    /// 由于服务器返回的remind_in字段已经不使用，重写这个方法防止报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // 打印对象的时候调用
    override var description: String {
        
        // 通过KVC将对象转换为字典
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid", "avatar_large", "screen_name"]).description
    }
    
    // MARK:- 归档和解档
    /// 归档
    func encode(with aCoder: NSCoder) {
        // 归档当前类中的属性
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(expires_date, forKey: "expires_date")
    }
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        // 通过key解档的值，保存到对应的属性
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
    }
}


