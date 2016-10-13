//
//  XYEmoticonViewCell.swift
//  EmoticonKeyboard
//
//  Created by mofeini on 16/10/3.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYEmoticonViewCell: UICollectionViewCell {
 
    var emoticonItem : XYEmoticonItem? {
    
        didSet {
            
            guard let emoticonItem = emoticonItem else {
                return
            }
            
            // 设置按钮的表情
            emoticonBtn.setImage(UIImage.init(contentsOfFile: emoticonItem.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticonItem.emojiCode, for: .normal)
            
            
            // 设置删除按钮
            if emoticonItem.isRemove { // 是删除模型
                // 根据模型决定控件显示什么数据
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    lazy var emoticonBtn : UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 设置UI
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        contentView.addSubview(emoticonBtn)
        
        emoticonBtn.frame = contentView.bounds
        
        emoticonBtn.isUserInteractionEnabled = false
        
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
    }
}

