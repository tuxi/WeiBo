//
//  UITextView-Extension.swift
//  EmoticonKeyboard
//
//  Created by mofeini on 16/10/4.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

extension UITextView {
    
    // 1.给textView插入表情
    func insertEmoticon(emoticonItem: XYEmoticonItem){
        
        // 1.判断是空的模型是
        if emoticonItem.isEmpty {
            return
        }
        
        // 2.判断是删除按钮模型时
        if emoticonItem.isRemove {
            deleteBackward() // 删除光标前面的文本
            return
        }
        
        // 3.判断是emoji表情时:emoji是字符串不需要进行图文混排
        if emoticonItem.emojiCode != nil {
            
            // 3.1获取光标所在位置的UITextRange
            let textRange = selectedTextRange
            
            // 3.2替换光标所在位置的文本
            replace(textRange!, withText: emoticonItem.emojiCode!)
            
            return
        }
        
        // 4.将普通表情通过图文混排插入到文本框
        // 4.1获取文本框上的属性字符串,并将其转换为可变属性字符串
        let attributeM = NSMutableAttributedString(attributedString: attributedText)
        
        // 4.2根据图片路径创建图片属性字符串
        let attachment = XYEmoticAttachment()
        attachment.chs = emoticonItem.chs
        attachment.image = UIImage(contentsOfFile: emoticonItem.pngPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attributeStr1 = NSAttributedString(attachment: attachment)
        
        // 4.3获取光标所在位置
        let range = selectedRange
        // 将图片字符串替换到光标所在的位置
        attributeM.replaceCharacters(in: range, with: attributeStr1)
        
        // 4.4重新给textView的属性文本赋值
        attributedText = attributeM
        self.font = font // 恢复原来的字体
        
        // 4.5将光标放置到插入表情的后面
        selectedRange = NSRange(location: range.location + 1, length: 0)
        
    }
    
    // 2.获取textView属性字符串对应的表情字符串
    func getEmoticonString() -> String {
        
        // 1.获取textView的属性字符串
        let attributeStrM = NSMutableAttributedString(attributedString: attributedText!)
        
        // 2.遍历属性字符串(从0的位置开始遍历)
        let attributeStrRange = NSRange(location: 0, length: attributeStrM.length)
        attributeStrM.enumerateAttributes(in: attributeStrRange, options: [], using: { (attributes, attributeStrRange, _) in
            
            // 如果有attributes["NSAttachment"]这个key，就是图片属性文本,并将其转换为XYEmoticAttachment，这个类中定义了要替换的字符串属性
            if let attachment = attributes["NSAttachment"] as? XYEmoticAttachment {
                
                attributeStrM.replaceCharacters(in: attributeStrRange, with: attachment.chs!)
            }
        })
        
        return attributeStrM.string
        

    }

    
}
