//
//  XYPicPickerCollectionView.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/2.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit


let picPikerCellId = "picPikerCellId"

let margin : CGFloat = 15

class XYPicPickerCollectionView: UICollectionView {

    
    // MARK:- 懒加载数据
    var images : [UIImage] = [UIImage]()  { // 接收存放选择图片的数组
        didSet {
            reloadData()
        }
    }
    
    // MARK:- 系统回掉
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        
        // 注册cell
        self.register(UINib.init(nibName: "XYPicPikerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: picPikerCellId)
        
        // 取出布局
        let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        // 每个item的宽高
        let itemWH = (UIScreen.main.bounds.width - 4 * margin) / 3
        
        flowLayout.itemSize = CGSize(width: itemWH, height: itemWH)
        
        flowLayout.minimumLineSpacing = margin
        flowLayout.minimumInteritemSpacing = margin
        
        // 设置内边距
        contentInset = UIEdgeInsetsMake(margin, margin, 0, margin)
    }

}

extension XYPicPickerCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 没有选择图片时，默认也要有个加号按钮，所以需要多一个item
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPikerCellId, for: indexPath) as! XYPicPikerCollectionViewCell
        // 防止数组越界
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.row] : nil
        
        return cell
    }
}
