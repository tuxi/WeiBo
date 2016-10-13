//
//  XYStatusViewModel.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/30.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYStatusViewModel: NSObject {

    var statusItem : XYStatusItem?
    
    // MARK:- 处理微博模型数据
    var cteatedText : String?                   // 微博的创建日期
    var sourceText : String?                    // 微博的来源
    var picURLs : [URL] = [URL]()               // 微博配图的url数组
    var cellHeight : CGFloat = 0                // 保存cell的高度
    
    
    // MARK:- 对用户数据处理自定义的属性
    var verifiedImage : UIImage?                //  用户的认证等级图片
    var vipImage : UIImage?                     //  用户的vip图标
    var profileUrl : URL?                       //  用户头像
    
    // MARK:- 自定义构造函数
    init(statusItem : XYStatusItem) {
        self.statusItem = statusItem
        
        // 1.处理创建时间
        if let createdAt = statusItem.created_at {
            cteatedText = NSDate.createDateString(createAtStr: createdAt)
        }
        
        // 2.处理微博来源
        if let source_text = statusItem.source, source_text != "" { // 还有判断服务器返回""空字符串的情况，这种情况程序会崩溃
            
            // 2.对来源的字符串进行处理
            // 2.1获取起始为准和截取长度
            let startIndex = (source_text as NSString).range(of: ">").location + 1       // 起始位置
            let length = (source_text as NSString).range(of: "</").location - startIndex // 截取长度
            
            // 2.2截取字符串
            sourceText = (source_text as NSString).substring(with: NSRange(location: startIndex, length: length))

        }
        
        // 3.处理用户认证
        let verifiedType = statusItem.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        
        // 4.处理vip头像
        let mbrank = statusItem.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        // 5.处理用户头像url
        let profileUrlString = statusItem.user?.profile_image_url ?? ""
        profileUrl = URL(string: profileUrlString)
        
        // 6.处理微博配图的url
        // 一个微博配图与转发微博的配图只会显示其中一个
        let picURLDicts = statusItem.pic_urls?.count != 0 ? statusItem.pic_urls : statusItem.retweeted_status?.pic_urls
        // 空值校验
        if let picURLDicts = picURLDicts {
            for picURLDict in picURLDicts {
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    
                    continue
                }
                
//                 picURLString = picURLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
                
                picURLs.append(URL(string: picURLString)!)
        
            }
        }
    }

    
}
