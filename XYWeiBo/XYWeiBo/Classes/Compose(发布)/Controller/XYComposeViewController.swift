//
//  XYComposeViewController.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/2.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit
import SVProgressHUD

class XYComposeViewController: UIViewController {

    // MARK:- 控件
    @IBOutlet weak var textView: XYComposeTextView!
    @IBOutlet weak var picPikerView: XYPicPickerCollectionView!
    
    // MARK:- 约束
    @IBOutlet weak var toolBarBottomConstr: NSLayoutConstraint!
    @IBOutlet weak var picPikerViewHeightConstr: NSLayoutConstraint!
    
    // MARK:- 懒加载属性
    lazy var titleView : XYComposeTitleView = XYComposeTitleView.titleViewFromNib()
    lazy var images : [UIImage] = [UIImage]() // 存放所有选择的图片
    lazy var emoticonVc : XYEmoticonViewController = XYEmoticonViewController {[weak self] (emoticonItem) in
        
        // 给textView插入输入的表情
        self?.textView.insertEmoticon(emoticonItem: emoticonItem)
        // 手动触发textView的代理方法:输入表情也是等于输入文字
        self?.textViewDidChange((self?.textView)!)
    }
    

    
    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigationBar()
        
        // 监听键盘frame发送改变的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrameNotification), name: .UIKeyboardWillChangeFrame, object: nil)
        // 监听点击了添加图片按钮的点击事件
        NotificationCenter.default.addObserver(self, selector: #selector(clickAddPictureButton(notification:)), name: XYClickAddPictureButtonNotification, object: nil)
        // 监听点击了删除图片按钮的点击事件
        NotificationCenter.default.addObserver(self, selector: #selector(clickRemovePictureButton(notification:)), name: XYClickRemovePictureButtonNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textView.becomeFirstResponder()
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
        print("发布控制器已释放")
    }

}



// MARK:- 设置UI界面
extension XYComposeViewController {

    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(composeCloseBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(composeBtnClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        navigationItem.titleView = titleView
        
        textView.delegate = self
    }

}

// MARK:- 事件监听
extension XYComposeViewController {
    
    /// 关闭按钮的点击事件
    func composeCloseBtnClick() {
        
        self.textView.resignFirstResponder()
     
        dismiss(animated: true, completion: nil)
    }
    
    /// 发布按钮的点击事件: 发布微博
    func composeBtnClick() {
        
        // 1.发布文本微博
        // 1.获取textView上表情的字符串
        let emoticonStr = textView.getEmoticonString()
        
        
        // 2.定义一个闭包
        let finishedCallBack = { (isSucces: Bool) -> () in
        
            if isSucces { // 发送微博成功
                SVProgressHUD.showSuccess(withStatus: "发布微博成功")
                self.dismiss(animated: true, completion: nil)
                return
            }             // 发送微博失败
            
            SVProgressHUD.showError(withStatus: "发布微博失败")
            
        }

        // 发布微博注意:图片微博：由于权限问题只能发一张图片
        // 2.1通过判断用户发送的微博有没有图片，决定使用什么接口发送微博
        if let image = images.first {  // 用户发布的微博有图片，就使用有图片接口发送
            
            XYNetworkTools.shareInstace.senderStatus(statusText: emoticonStr, image: image, isSuccesCallBack: finishedCallBack)
        } else {                       // 用户发布的微博没有图片，使用文本接口发送
            
            XYNetworkTools.shareInstace.senderStatus(statusText: emoticonStr, isSuccesCallBck: finishedCallBack)
        }
    }
    
    /// 监听键盘frame即将发送改变的通知
    func keyboardWillChangeFrameNotification(notification: Notification) {
        
        // 获取键盘的动画时间
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // 获取键盘出现后的frame
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = keyboardFrame.origin.y
        
        // 计算键盘出现后toolBar的底部约束
        toolBarBottomConstr.constant = UIScreen.main.bounds.size.height - keyboardY
        
        UIView .animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    /// 点击工具栏上emoticon表情时调用
    @IBAction func emoticonItemClick(_ sender: AnyObject) {
        
        // 退出第一响应者
        textView.resignFirstResponder()
        
        // 切换键盘
        textView.inputView = textView.inputView == nil ? emoticonVc.view : nil
        
        // 成为第一响应者
        textView.becomeFirstResponder()
    }
    
    /// 点击照片选择按钮的点击事件
    @IBAction func picPickerButtonClick() {
        
        // 设置照片选择器view的高度约束
        self.picPikerViewHeightConstr.constant = UIScreen.main.bounds.size.height * 0.65
        self.textView.resignFirstResponder()
        
        UIView.animate(withDuration: 0.5) { 
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    /// 当接收到点击添加图片按钮的通知后调用
    func clickAddPictureButton(notification: Notification) {
        
        // 添加图片
        addPicture()
        
    }
    
    /// 当接收到点击删除图片按钮的通知后调用
    func clickRemovePictureButton(notification: Notification) {
        
        // 删除图片
        removePicture(notification: notification)
    }
    
}

// MARK:- 添加和删除照片
extension XYComposeViewController {

    /// 添加图片
    func addPicture() {
        
        // 1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return // 照片资源库不可用时直接返回
        }
        
        // 2.创建照片选择控制器
        let imagePickVc = UIImagePickerController()
        
        // 3.设置照片的来源
        imagePickVc.sourceType = .photoLibrary
        
        // 4.设置代理
        imagePickVc.delegate = self
        
        // 设置modal的弹出样式为自定义
        // 目的:弹出后不让上一个控制器的view消失，因为我在上一控制器的显示完成的方法中让键盘弹出了，所以每次view显示都会弹出，这样不好，设置为custom后，modal出新的控制器后，上一控制器的view也不会消失，退出modal会所以也不会调用view显示的方法
        imagePickVc.modalPresentationStyle = .custom
        // 5.弹出照片选择控制器
        present(imagePickVc, animated: true, completion: nil)
    }
    
    /// 删除图片
    func removePicture(notification: Notification) {
        
        // 1.获取点击删除上的图片
        guard let imaage = notification.object as? UIImage else {
            return
        }
        
        // 2.获取图片在images数组中的下标值
        guard let index = images.index(of: imaage) else {
            return
        }
        
        // 3.从数组中删除这个图片
        images.remove(at: index)
        
        // 4.重新给collectionView中的images赋值,当collectionView中的images监听到值发送改变时就会刷新数据
        picPikerView.images = images
    }
}

extension XYComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // 每次选择照片时调用
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 1.获取选择的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 2.将选中的照片添加到数组中
        images.append(image)
        
        // 3.将照片数组传递出去
        picPikerView.images = images
        
        // 4.退出照片选中器
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension XYComposeViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.textView.placeHodlerLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
}

extension XYComposeViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.textView.resignFirstResponder()
    }
}


