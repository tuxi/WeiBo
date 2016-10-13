//
//  XYPicPikerCollectionViewCell.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/2.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYPicPikerCollectionViewCell: UICollectionViewCell {

    // MARK:- 控件属性
    @IBOutlet weak var addPicButton: UIButton!
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var removePicButton: UIButton!
    
    var image : UIImage? {
        didSet{
            if (image != nil) {
                
                picView.image = image
                addPicButton.isUserInteractionEnabled = false
                removePicButton.isHidden = false
            } else {
                picView.image = nil
                addPicButton.isUserInteractionEnabled = true
                removePicButton.isHidden = true
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}

// MARK:- 事件监听
extension XYPicPikerCollectionViewCell {
    
    // 点击加号按钮时，跳转到相册
    @IBAction func addPicButtonClick(_ sender: AnyObject) {
        
        
        // 由于当前cell非控制器，且父控件也非控制器，这里无法弹出控制器，使用通知的方式
        // 发布通知
        NotificationCenter.default.post(name: XYClickAddPictureButtonNotification, object: nil)
        
    }
    
    // 点击删除图片按钮的点击事件
    @IBAction func removePicButtonClick(_ sender: AnyObject) {
        
        // 发布点击了删除按照片按钮的通知:并将删除的这张图片作为参数传递出去，方便外界知道要删除哪张图片
        NotificationCenter.default.post(name: XYClickRemovePictureButtonNotification, object: picView.image)
    }
}
