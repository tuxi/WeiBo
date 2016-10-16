//
//  XYStatusItem.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/30.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYStatusItem: NSObject {

    // MARK:- 属性
    var created_at : String?                     // 微博创建时间
    var source : String?                         // 微博来源
    var text : String?                           // 微博的正文
    var id : Int = 0                             // 微博的ID
    var idstr : String?                          // 字符串类型的微博ID
    var user : XYUserItem?                       // 微博用户个人信息模型
    var pic_urls : [[String : String]]?          // 微博配图的URL数组
    var retweeted_status : XYStatusItem?         // 转发的微博
    

    
    // MARK:- 自定义构造函数
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
        if let userDict = dict["user"] as? [String : AnyObject] {
            self.user = XYUserItem(dict: userDict)
        }
        
        if let retweetedStatus = dict["retweeted_status"] as? [String: AnyObject] {
            self.retweeted_status = XYStatusItem(dict: retweetedStatus)
        
        }
        
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

