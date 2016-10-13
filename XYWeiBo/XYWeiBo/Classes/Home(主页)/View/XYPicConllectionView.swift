//
//  XYPicConllectionView.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/1.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit
import SDWebImage

class XYPicConllectionView: UICollectionView {

    // MARK:- 模型属性
    var picUrls : [URL] = [URL]() {
        didSet {
            
            // 刷新表格
            self.reloadData()
        }
    }
    
    
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置collectionView的数据源
        dataSource = self
        delegate = self
        
        self.isScrollEnabled = false
    }

}

extension XYPicConllectionView: XYAnimationPresentedDelegate {
    
    
    // 获取图片相对屏幕显示的起始位置
    func getStartFrame(indexPath: NSIndexPath) -> CGRect {
        
        // 1.获取当前indexPath对应的cell
        let cell = cellForItem(at: indexPath as IndexPath)!
        
        // 2.将cell的frame坐标转换为相对屏幕的坐标
        let frame = convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        return frame
    }
    
    // 获取图片最终在图片浏览器中显示的位置
    func getEndFrame(indexPath: NSIndexPath) -> CGRect {
        
        // 1.取出indexPath对应的图片url
        let picURL = picUrls[indexPath.item]
        // 根据图片url通过SDWebimage获取磁盘缓存的图片
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        // 根据图片长度确定返回长图和短图两种类型图片frame
        let width = UIScreen.main.bounds.size.width
        let height = width / (image?.size.width)! * (image?.size.height)!
        var y : CGFloat = 0
        if height > UIScreen.main.bounds.size.height {  // 长图
            y = 0
        } else {                                        // 短图
            y = (UIScreen.main.bounds.size.height - height) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: width, height: height)
        
    }
    
    // 获取临时用于显示图片的UIImageView对象
    func getImageView(indexPath: NSIndexPath) -> UIImageView {
        
        // 1.创建imageViewd对象
        let imageView = UIImageView()
        
        // 2.取出indexPath对应的图片url
        let picURL = picUrls[indexPath.item]
        //2.1 根据图片url通过SDWebimage获取磁盘缓存的图片
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        // 3.设置imageView属性
        imageView.image = image
        imageView.contentMode = .scaleAspectFill // 按照原始宽高比例填充
        imageView.clipsToBounds = true // 超出父控件的裁切掉
        
        return imageView
        
    }
}

// MARK:- collectionView的代理和数据源方法
extension XYPicConllectionView : UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCollectionViewCell", for: indexPath) as! XYPicViewCell
        
        
        cell.picURL = picUrls[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 点击cll时，通知HomeViewController弹出照片浏览器
        let userInfo = [statusPicIndexPathKey: indexPath, statusPicURLsKey: picUrls] as [String : Any]
        NotificationCenter.default.post(name: XYClickStatusPictureNotification, object: self, userInfo: userInfo)
    }
    
}

// MARK:- XYPicViewCell类
class XYPicViewCell: UICollectionViewCell {
    
    // MARK:- 拖线控件
    @IBOutlet weak var iconView: UIImageView!
    
    var picURL : URL? {
        
        didSet {
            guard let picURL = picURL else {
                return
            }
            
            // 设置配图图
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "avatar_default_big"))
        }
        
    }
    
    
}
