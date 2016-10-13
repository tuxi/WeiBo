//
//  XYProgressView.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/5.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYProgressView: UIView {
    
    // MARK:- 进度属性
    var progress : CGFloat = 0 {
        didSet {
            
            // 只要进度发送改变就重新绘制
            setNeedsDisplay()
        }
    }
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint(x: rect.size.width * 0.5, y: rect.size.height * 0.5)
        let radius = rect.width * 0.5 - 3  // 圆角半径
        let startAngle = CGFloat(-M_PI)    // 开始绘制的位置
        let endAngle = CGFloat(2 * M_PI) * progress + startAngle   // 结束绘制的位置
        
        // 1.创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // 2.绘制一条中心点的线
        path.addLine(to: center)
        path.close() // 关闭路径
        
        // 3.设置绘制的颜色
        UIColor.init(white: 1.0, alpha: 0.6).setFill()
        
        // 4.开始绘制
        path.fill() 
    }

}
