//
//  XYPhotoBrowserViewController.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/5.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit
import SVProgressHUD

class XYPhotoBrowserViewController: UIViewController {
    
    // MARK:- 数据属性
    let indexPath : NSIndexPath?
    let picURLs : [NSURL]?
    
    // MARK:- 懒加载控件
    lazy var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: XYPhotoBrowerFlowLayout())
    lazy var closeButton : UIButton = UIButton(title: "关  闭", bgColor: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14))
    lazy var saveButton : UIButton = UIButton(title: "保  存", bgColor: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14))
    
    // MARK:- 自定义构造函数
    init(indexPath: NSIndexPath, picURLs: [NSURL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI
        setupUI()
    }
    override func loadView() {
        super.loadView()
        
        view.frame.size.width += 20
    }
    
    deinit {
        print("照片浏览器已经释放")
    }

}

let photoBrowerCellID = "photoBrowerCellID"
// MARK:- 设置UI界面
extension XYPhotoBrowserViewController {
    
    /// 设置UI
    func setupUI() {
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        
        // 2.设置子控件frame
        collectionView.frame = view.bounds
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let views = ["closeButton": closeButton, "saveButton": saveButton]
        var constrs = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[closeButton(90)]", options: [], metrics: nil, views: views)
        constrs += NSLayoutConstraint.constraints(withVisualFormat: "V:[closeButton(32)]-20-|", options: [], metrics: nil, views: views)
        constrs += NSLayoutConstraint.constraints(withVisualFormat: "H:[saveButton(90)]-40-|", options: [], metrics: nil, views: views)
        constrs += NSLayoutConstraint.constraints(withVisualFormat: "V:[saveButton(32)]-20-|", options: [], metrics: nil, views: views)
        self.view.addConstraints(constrs)
        
        // 3.设置collectionView
        collectionView.dataSource = self
        collectionView.register(XYPhotoBrowerCell.self, forCellWithReuseIdentifier: photoBrowerCellID)
        
        // 4.监听按钮的点击
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveImageToPhotos), for: .touchUpInside)
        
        // 5.让collectionView滚动到对应的页面
        collectionView.scrollToItem(at: indexPath as! IndexPath, at: .left, animated: false)
        
        SVProgressHUD.setMinimumDismissTimeInterval(2)
    }
}

// MARK:- 事件监听
extension XYPhotoBrowserViewController {

    /// 关闭照片浏览器
    func closeButtonClick() {
        
        dismiss(animated: true, completion: nil)
    }
    
    /// 保存图片到相册
    func saveImageToPhotos() {
        
        // 1.取出正在显示中的cell
        let cell = collectionView.visibleCells.first as! XYPhotoBrowerCell
        let image = cell.imageView.image // 拿到cell上的图片
        
        // 2.保存image到相册中
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
   // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: Any) {
        
        if error != nil { // 保存失败
            SVProgressHUD.showError(withStatus: "保存相册失败")
        } else {
            SVProgressHUD.showInfo(withStatus: "保存成功")
            
        }
    }
}

// MARK:- collectionView的数据源方法
extension XYPhotoBrowserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return picURLs!.count // 有多少url就展示多少张图片
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowerCellID, for: indexPath) as! XYPhotoBrowerCell
        
        cell.picURL = picURLs?[indexPath.item]
        cell.delegate = self // 设置cell的代理
        return cell
    }
}

// MARK:- cell的代理方法 
extension XYPhotoBrowserViewController: XYPhotoBrowerCellDelegate {
    
    // 当点击了imageView时调用
    internal func photoBrowerCellClickImageView(cell: XYPhotoBrowerCell) {
     
        closeButtonClick()
    }
}

// MARK:- 消失动画的代理方法
extension XYPhotoBrowserViewController: XYAnimationDismissDelegate {
    
    func getImageViewForDismissView() -> UIImageView {
        
        // 1.获取正在屏幕上显示的cell
        let cell = collectionView.visibleCells.first as! XYPhotoBrowerCell
        
        // 2.创建临时imageView(用于做消失动画)
        let imageView = UIImageView()
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        
        imageView.contentMode = .scaleAspectFill  // 按原始比例填充
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    func getIndexPathForDismissView() -> NSIndexPath {
        
        // 1.获取正在屏幕上显示的cell
        let cell = collectionView.visibleCells.first!
        
        // 2.拿到这个cell对应的indexPath
        return collectionView.indexPath(for: cell)! as NSIndexPath
    }
}



// MARK:- 自定义流水布局
class XYPhotoBrowerFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        // 设置布局属性
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
}
