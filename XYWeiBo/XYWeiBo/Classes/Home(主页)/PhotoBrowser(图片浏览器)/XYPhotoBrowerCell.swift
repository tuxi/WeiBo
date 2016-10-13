//
//  XYPhotoBrowerCell.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/5.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit
import SDWebImage

protocol XYPhotoBrowerCellDelegate {
    
    func photoBrowerCellClickImageView(cell: XYPhotoBrowerCell)
}

class XYPhotoBrowerCell: UICollectionViewCell {
    
    // MARK:- 代理
    var delegate : XYPhotoBrowerCellDelegate?
    
    
    // MARK:- 定义属性
    var picURL : NSURL? {
        didSet {
            // 根据每个图片来计算imageView的frame
            setupContent(picURL: picURL)
          
        }
    }
    
    // MARK:- 懒加载控件
    lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageView : UIImageView = UIImageView()
    lazy var progressView : XYProgressView = XYProgressView()  // 进度控件
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 设置UI界面
        setupUI()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension XYPhotoBrowerCell {

    func setupUI() {
     
        // 1.添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        
        // 2.设置frame
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
     
        // 3.设置子控件属性
        progressView.isHidden = true // 默认隐藏
        progressView.backgroundColor = UIColor.clear
        
        // 4.给imageView添加点按手势
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(closePhotoBrower)))
    }
    
    func setupContent(picURL: NSURL?) {
    
        // 0.nil值校验
        guard let picURL = picURL else {
            return
        }
        
        // 1.从沙盒缓存中取出image
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)!
        
        // 2.计算image等比例的frame
        let width = UIScreen.main.bounds.width
        let height = width / image.size.width * image.size.height // 拿到宽度的比例 ➗ 真实的高度
        var y : CGFloat = 0.0
        if height > UIScreen.main.bounds.size.height { // 长图
            y = 0
            
            
        } else {                                       // 短图
            y = (UIScreen.main.bounds.size.height - height) / 2
            
        }
        imageView.frame = CGRect(x: 0.0, y: y, width: width, height: height)
        
        // 3.设置imageView的图片
        // 当下载图片时显示进度
        self.progressView.isHidden = false
        imageView.sd_setImage(with: getBigImageURL(smallImageURL: picURL), placeholderImage: image, options: [], progress: { (currentProgress, totalProgress) in
            
            self.progressView.progress = CGFloat(currentProgress) / CGFloat(totalProgress)
            
            }) { (_, _, _, _) in
                self.progressView.isHidden = true
                
        }
        
        // 4.设置scrollView的contentSize
        scrollView.contentSize = CGSize(width: width, height: height)

        
    }
    
    // 通过传入小图的NSURL路径获取大图的URL
    // 新浪的图片URL是有规则的:小图的URL有thumbnail字符，中图有bmiddle，大图是large，所以我们把小图的url字符串中thumbnail字符替换为bmiddle就可以获取大=中图的url
    func getBigImageURL(smallImageURL: NSURL) -> URL {
        
        let smallString = smallImageURL.absoluteString
        
        let bigString = smallString?.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        
        return NSURL(string: bigString!)! as URL
        
    }
}

extension XYPhotoBrowerCell {

    func closePhotoBrower() {
       
        // 通知代理有人点击我了，请关闭照片浏览器
        delegate?.photoBrowerCellClickImageView(cell: self)
    }
}
