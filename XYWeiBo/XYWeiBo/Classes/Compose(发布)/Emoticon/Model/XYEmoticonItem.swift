//
//  XYEmoticonItem.swift
//  EmoticonKeyboard
//
//  Created by mofeini on 16/10/3.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYEmoticonItem: NSObject {

    // MARK:- 模型属性
    var code : String? {                 // emoji的简体字符串
        didSet{
        
            guard let code = code else {
                return
            }
            
            // 1.创建扫描器
            let scanner = Scanner(string: code)
            
            // 2.调用方法，扫描出code中的值后通过value的地址传递给value
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            
            // 3.将value转换为字符
            let c = Character(UnicodeScalar(value)!)
            
            // 4.将字符转换为字符串
            emojiCode = String(c)
            
        }
        
    }
    var png : String? {                 // 普通表情对应的图片名称
        didSet{
            
            guard let png = png else {
                return
            }
            
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs : String?                   // 普通表情对应的文字
    
    // MARK:- 接收处理后的模型数组
    var emojiCode : String?
    var pngPath : String?
    var isRemove : Bool = false
    var isEmpty : Bool = false
    
    // 当外界调用此方法创建模型时，告知是不是删除模型
    init(isRemove: Bool) {
        super.init()
        
        self.isRemove = isRemove   
    }
    
    // 当外界调用此方法创建模型时，告知是不是空白
    init(isEmpty: Bool) {
        super.init()
        
        self.isEmpty = isEmpty
    }
    

    init(dict: [String: String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["code", "png", "chs"]).description
    }
    
}
