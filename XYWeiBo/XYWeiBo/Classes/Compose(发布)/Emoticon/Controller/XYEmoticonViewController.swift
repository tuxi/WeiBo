//
//  XYEmoticonViewController.swift
//  EmoticonKeyboard
//
//  Created by mofeini on 16/10/3.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYEmoticonViewController: UIViewController {
    
    // MARK:- 属性
    var emoticonCallBack : (_ emoticonItem: XYEmoticonItem) -> ()
    
    // MARK:- 懒加载控件
    lazy var manager : XYEmoticonManger = XYEmoticonManger()
    
    lazy var collectionView : UICollectionView = {
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: XYEmoticonFlowLayout())
        
        return collectionView
    }()
    lazy var toolBar : UIToolbar = {
    
        let toolbar = UIToolbar()
        
        return toolbar
    }()
    
//    lazy var contentView : UIView = {
//    
//        let contentView = UIView()
//        
//        return contentView
//    }()
//    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI
        setupUI()
    }
    
    // MARK:- 自定义构造函数
    init(emoticonCallBack: @escaping (_ emoticonItem : XYEmoticonItem) -> ()) {
        
        self.emoticonCallBack = emoticonCallBack
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

let emoticonCellID = "emoticonCellID"

// MARK:- 设置UI
extension XYEmoticonViewController {
    
    func setupUI() {
        
        

        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        collectionView.backgroundColor = UIColor.darkGray
        
        // 2.设置frame
        view.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["toolBar": toolBar, "collectionView": collectionView] as [String : Any]
        
        var constr = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        constr += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(constr)
        
        // 3.准备conllectionView
        prepareForCollectionView()
        
        // 4.准备toolBar
        prepareForToolBar()

    }
    
    func prepareForCollectionView() {
        
        collectionView.register(XYEmoticonViewCell.self, forCellWithReuseIdentifier: emoticonCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func prepareForToolBar() {
        
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            
            let item = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(toolBarTitleButtonItemClick(item:)))
            
            item.tag = index
            index += 1
            tempItems.append(item)
            // 添加弹簧
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        // 设置toolBar的items数组
        // 删除最后一个弹簧
        tempItems.removeLast()
        toolBar.items = tempItems // 由于toolBar.items属性默认为nil，所以不能直接给其添加数据，只能先添加到临时数组，再进行赋值给他
        toolBar.tintColor = UIColor.orange
    }
}

// MARK:- 事件监听
extension XYEmoticonViewController {

    func toolBarTitleButtonItemClick(item: UIBarButtonItem) {
        
        // 1.获取按钮的tag
        let tag  = item.tag
        
        // 2.根据tag获取按钮所在的当前组
        let indexPath = IndexPath(item: 0, section: tag)
        
        // 3.滚动到对应的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

// MARK:- collectionView数据源和代理方法
extension XYEmoticonViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = manager.packages[section]
        
        return package.emoticonItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emoticonCellID, for: indexPath) as!XYEmoticonViewCell
        
        let package = manager.packages[indexPath.section]
        
        cell.emoticonItem = package.emoticonItems[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 1.取出点击的那个模型
        let package = manager.packages[indexPath.section]
        let emonitonItem = package.emoticonItems[indexPath.row]
        
        // 2.将点击的模型插入到最近分组中,并删除点击的这个模型
        insertRecentlyEmoticon(emoticonItem: emonitonItem)
        
        // 3.将点击的表情作为参数在闭包中回调出去
        emoticonCallBack(emonitonItem)
        
    }
    
    func insertRecentlyEmoticon(emoticonItem: XYEmoticonItem) {
        
        // 0.判断如果是删除按钮模型或空白模型，就不做任何操作
        if emoticonItem.isRemove || emoticonItem.isEmpty {
            return
        }
        
        // 1. 删除点击的模型
        // 判断最近分组中有没有这个表情
        if (manager.packages.first?.emoticonItems.contains(emoticonItem))! {
            // 最近分组中有这个表情，删除自己
            let index = manager.packages.first?.emoticonItems.index(of: emoticonItem)
            manager.packages.first?.emoticonItems.remove(at: index!)
        } else {
            // 最近分组中没有这个表情,删除倒数第2个，倒数第一为删除模型，不能删除
            manager.packages.first?.emoticonItems.remove(at: 19)
        }
        
    
        // 2.将点击的按钮插入到最近分组的最前面
        manager.packages.first?.emoticonItems.insert(emoticonItem, at: 0)
    }
}

class XYEmoticonFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        // 需求:每个item的宽高一样，每行展示7个item，每列3个
        // 1.计算每个item的宽高
        let itemWH = UIScreen.main.bounds.size.width / 7
        
        // 2.设置布局
        itemSize = CGSize(width: itemWH, height: itemWH)
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        // 3.设置collectionView的属性
        // 计算cell中间的间隙：由于cell中间一行上下游两条间隔，需要去掉
        let middleMagin = ((collectionView?.frame.size.height)! - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: middleMagin, left: 0, bottom: middleMagin, right: 0)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        
        
    }
}

