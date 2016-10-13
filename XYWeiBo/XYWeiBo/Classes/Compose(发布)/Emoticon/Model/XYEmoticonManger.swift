//
//  XYEmoticonManger.swift
//  EmoticonKeyboard
//
//  Created by mofeini on 16/10/3.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYEmoticonManger: NSObject {

    var packages : [XYEmoticonPackage] = [XYEmoticonPackage]()
    
    override init () {
        // 1.添加最近表情的包
        packages.append(XYEmoticonPackage(identifier: ""))
        
        // 2.添加默认表情的包
        packages.append(XYEmoticonPackage(identifier: "com.sina.default"))
        
        // 3.添加emoji表情的包
        packages.append(XYEmoticonPackage(identifier: "com.apple.emoji"))
        
        // 4.添加浪小花表情的包
        packages.append(XYEmoticonPackage(identifier: "com.sina.lxh"))
    }

}
