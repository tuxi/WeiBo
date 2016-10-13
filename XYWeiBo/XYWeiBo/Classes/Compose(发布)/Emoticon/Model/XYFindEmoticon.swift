//
//  XYFindEmoticon.swift
//  显示表情
//
//  Created by mofeini on 16/10/5.
//  Copyright © 2016年 sey. All rights reserved.
//  通过匹配文本框中的chs字符，查找对应表情的png路径，通过图文混排，获取属性字符串

import UIKit

class XYFindEmoticon: NSObject {
    
    static let shareInstance : XYFindEmoticon = XYFindEmoticon()
    lazy var manager : XYEmoticonManger = XYEmoticonManger()

    // 通过字符串及label的字体，获取对应的属性字符串
    func getAttributeString(text: String, labelFont: UIFont) -> NSAttributedString? {
        
        // 1.创建正则表达式规则: 匹配微博中的表情字符[表情字符]
        let pattern = "\\[.*?\\]"
        
        // 2.创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        // 3.开始匹配
        let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
        
        // 4.获取匹配结果
        // 先将微博文本转换为可变的属性字符串，方便把结果替换到里面的
        let attributeStrM = NSMutableAttributedString(string: text)
        
        // 从后往前遍历结果，因为每次替换文字为表情后，微博文字的range就会发生改变，导致不准确，从后往前遍历时后面发生发布不影响前面的
        var i = results.count - 1;
        for _ in results {
            // 4.1获取结果
            let result = results[i]
            // 4.2获取chs
            let chs = (text as NSString).substring(with: result.range)
            
            // 4.3根据chs拿到图片的路径
            guard let pngPath = findPngPath(chs: chs) else {
                return nil
            }
            
            
            // 5.创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            let attributeStr = NSAttributedString(attachment: attachment)
            attachment.bounds = CGRect(x: 0, y: -4, width: labelFont.lineHeight, height: labelFont.lineHeight)
            attributeStrM.replaceCharacters(in: result.range, with: attributeStr)
            
            i -= 1
        }
        
         return attributeStrM
    }
    
    // 查找表情的全路径
    private func findPngPath(chs: String) -> String? {
        
        for package in manager.packages {
            
            for emoticonItem in package.emoticonItems {
            
                if emoticonItem.chs == chs {  // 如果文本框上的chs与表情模型中的chs相同，就是表情
                
                    return emoticonItem.pngPath      // 是表情，就返回这个表情的png路径
                }
            }
            
            
        }
            return nil
        
    }
    
}
