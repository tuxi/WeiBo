//
//  XYUserAccountViewModel.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/30.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYUserAccountViewModel {

    // MARK:- 将类设计为单例
    static let shareInstance : XYUserAccountViewModel = XYUserAccountViewModel()
    
    // MARK:- 属性
    var userAccount : XYUserAccount?
    
    // MARK:- 计算属性
    var accountPath : String {
        // 1获取沙盒路径
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        // 2拼接保存的全路径
        return (accountPath as NSString).appendingPathComponent("userAccount.plist")
    }
    
    var isLogin : Bool {
        
        if userAccount == nil {
            return false
        }
        
        guard let expiresDate = userAccount?.expires_date else {
            return false
        }
        
        // 判断日期是否过期 : 通过判断是否为升序，如果为升序就是没有过期
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    
    init() {
        
        // 1.读取用户信息
        userAccount = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? XYUserAccount
        
    }
    
    
}
