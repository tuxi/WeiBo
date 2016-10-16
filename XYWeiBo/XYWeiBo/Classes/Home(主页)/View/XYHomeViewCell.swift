//
//  XYHomeViewCell.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/30.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit
import SDWebImage

/// 边缘间距
private let edgeMargin : CGFloat = 15.0
private let itemMargin : CGFloat = 10.0

class XYHomeViewCell: UITableViewCell {
    
    // MARK:- 拖线的控件
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var contentLabel: KILabel!
    @IBOutlet weak var picCollectionView: XYPicConllectionView!
    @IBOutlet weak var retweeted_statusLabel: KILabel!
    @IBOutlet weak var retweetedStatusBg: UIView!
    @IBOutlet weak var toolView: UIView!
    
    // MARK:- 拖线约束
    @IBOutlet weak var contentLabelWidthConstr: NSLayoutConstraint!
    @IBOutlet weak var picCollectionViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var picCollectionViewWidthConstr: NSLayoutConstraint!
    @IBOutlet weak var picCollectionViewBottomConstr: NSLayoutConstraint!
    @IBOutlet weak var retweetedStatusTopConstr: NSLayoutConstraint!
    // MARK:- 视图模型
    var viewModel : XYStatusViewModel? {
    
        didSet{
            
        
            // 1.头像
            iconView.sd_setImage(with: viewModel?.profileUrl, placeholderImage: UIImage(named: "avatar_default_small"))
            
            // 2.昵称
            screenNameLabel.text = viewModel?.statusItem?.user?.screen_name
            
            // 3.创建日期
            createdAtLabel.text = viewModel?.cteatedText
            
            // 4.vip头像
            vipView.image = viewModel?.vipImage
            
            // 5.认证
            verifiedView.image = viewModel?.verifiedImage
            
            // 6.来源
            if let source = viewModel?.sourceText {
            
                scoreLabel.text = "来自" + source
            }
            
            
            // 7.微博内容
            let text = viewModel?.statusItem?.text

            contentLabel.attributedText = XYFindEmoticon.shareInstance.getAttributeString(text: text!, labelFont: contentLabel.font)
        
            // 8.设置昵称的文字颜色
            screenNameLabel.textColor = viewModel!.vipImage == nil ? UIColor.black : UIColor.orange
        
            // 8.计算配图collectionView的尺寸
            let picViewSize = caculatePicViewSize(count: (viewModel?.picURLs.count)!)
            picCollectionViewWidthConstr.constant = picViewSize.width
            picCollectionViewHeightConstr.constant = picViewSize.height
            
            // 9.给picCollectionView中的picURLs传值
            picCollectionView.picUrls = viewModel!.picURLs
            
            
            // 10.转发微博的正文
            if viewModel?.statusItem?.retweeted_status != nil { // 有转发微博
                
                // 10.1社会转发微博的正文内容
                if let retweeted_statusText = viewModel?.statusItem?.retweeted_status?.text, let screenName = viewModel?.statusItem?.retweeted_status?.user?.screen_name {
                    
                    retweeted_statusLabel.text = "@" + "\(screenName):" +  (retweeted_statusText)
                }
                
                // 10.2显示转发微博背景
                retweetedStatusBg.isHidden = false
                
                // 10.3有转发微博时，设置转发微博正文控件顶部的约束为15
                retweetedStatusTopConstr.constant = 15
                
            } else { // 没有转发微博 
                // 隐藏转发微博背景
                retweetedStatusBg.isHidden = true
                
                // 没有转发微博时，设置转发微博正文控件顶部的约束为0
                retweetedStatusTopConstr.constant = 0
                
                // 删除转发微博的正文内容
                retweeted_statusLabel.text = nil
                
            }

            // 11.计算cell的高度
            // 计算好的高度就不再计算了
            if viewModel?.cellHeight == 0 {
                
                // 11.1强制布局
                layoutIfNeeded()
                // 11.2获取最大Y值就是cell的高度
                viewModel?.cellHeight = toolView.frame.maxY
                
            }
            
            
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置微博正文宽度的约束
        contentLabelWidthConstr.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        
        clickAttributeString()
    }
    
    /// 监听微博正文和转发微博上面属性文本的点击
    private func clickAttributeString() {
        // 微博正文 监听@谁的点击
        contentLabel.userHandleLinkTapHandler = { label, handle, range in
            print("点击了谁" + "\(handle)" + "----文字的长度:" + "\(range.length)")
        }
        
        // 微博正文 监听##话题的点击
        contentLabel.hashtagLinkTapHandler = { label, hashtag, range in
            print("点击的话题:" + "\(hashtag)" + "---文字的长度:" + "\(range.length)")
        }
        
        // 微博正文 监听URL的点击
        contentLabel.urlLinkTapHandler = { label, url, range in
            print("点击的url:" + "\(url)" + "---文字的长度:" + "\(range.length)")
        }
        
        // 转发微博正文 监听@谁的点击
        retweeted_statusLabel.userHandleLinkTapHandler = { label, handle, range in
            print("点击了谁" + "\(handle)" + "----文字的长度:" + "\(range.length)")
        }
        
        // 转发微博正文 监听##话题的点击
        retweeted_statusLabel.hashtagLinkTapHandler = { label, hashtag, range in
            print("点击的话题:" + "\(hashtag)" + "---文字的长度:" + "\(range.length)")
        }
        
        // 转发微博正文 监听URL的点击
        retweeted_statusLabel.urlLinkTapHandler = { label, url, range in
            print("点击的url:" + "\(url)" + "---文字的长度:" + "\(range.length)")
        }
        
    }
    


    // MARK:- 计算配图collectionView的尺寸
    private func caculatePicViewSize(count : Int) -> CGSize {
        
        // 1.没有配图
        if count == 0 {
            
            // 无配图时设置picCollectionView底部的约束为0
            picCollectionViewBottomConstr.constant = 0
            
            return CGSize(width: 0.0, height: 0.0)
        }
        
        // 有配图时设置picCollectionView底部的约束为10
        picCollectionViewBottomConstr.constant = 10
        
        // 取出流水布局
        let flowLayout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        // 2.单张配图
        if count == 1 {
            
            // 取出沙盒中SDWebImage缓存的图片
            let urlString = viewModel?.picURLs.first?.absoluteString // 单张图片时，数组中只有一个
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString)
            // 动态设置流水布局的itemSize
            flowLayout.itemSize = CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
            return CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
        }
        
        // 3.计算每个配图imageView的宽度和高度
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        // 超过1张图片的情况
        flowLayout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        // 4.四张图片
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin
            return CGSize(width: picViewWH + 1, height: picViewWH)
        }
        
        // 5.其他图片
        // 5.1计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        // 5.2 计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        // 5.3 计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
        
    }

}



