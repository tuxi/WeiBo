//
//  XYEmoticonPackage.swift
//  EmoticonKeyboard
//
//  Created by mofeini on 16/10/3.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYEmoticonPackage: NSObject {

    // 存放表情模型的数组
    var emoticonItems = [XYEmoticonItem]()
 
   
    init(identifier: String) {
        super.init()
        
        // 1.最近分组
        if identifier == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        
        // 2.根据标识拼接info.plist的全路径
        let plistPath = Bundle.main.path(forResource: "\(identifier)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        // 3.根据plist文件路径读取plist
        let array = NSArray(contentsOfFile: plistPath)! as! [[String: String]]
        
        // 4.遍历数组，读取数据，并将字典数组转换为模型字典
        var index = 0
        for var dict in array {
        
            // 处理下png的路径:拼接
            if let png = dict["png"] {
                dict["png"] = identifier + "/" + png
            }
            // 将数组中的字典转换为模型后，保存在emoticonItems模型数组中
            emoticonItems.append(XYEmoticonItem(dict: dict))
            index += 1
            
            // 5.判断是不是第20个按钮，如果是就添加删除模型
            if index == 20 {
                emoticonItems.append(XYEmoticonItem(isRemove: true))
                
                index = 0
            }
            
        }
        
        // 6.添加空白模型
        addEmptyEmoticon(isRecently: false)
    }
    
    func addEmptyEmoticon(isRecently: Bool) {
        
        let count = emoticonItems.count % 21
        if count == 0 && !isRecently { // 当没有空白表情，并且不是是最近表情
            return
        }
        
        for _ in count..<20 {
         
            emoticonItems.append(XYEmoticonItem(isEmpty: true))
        }
        
        emoticonItems.append(XYEmoticonItem(isRemove: true)) // 新的空白页也要添加删除按钮
    }
}
