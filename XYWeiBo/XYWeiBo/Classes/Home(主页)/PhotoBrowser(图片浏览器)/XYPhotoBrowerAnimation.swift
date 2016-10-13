//
//  XYPhotoBrowerAnimation.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/5.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

// MARK:- 协议: 面向协议开发，为了从别的类中获取图片的起始位置、结束显示的位置、UIImageView对象
protocol XYAnimationPresentedDelegate : NSObjectProtocol {
    
    // 获取图片相对屏幕显示的起始位置
    func getStartFrame(indexPath: NSIndexPath) -> CGRect
    
    // 获取图片最终在图片浏览器中显示的位置
    func getEndFrame(indexPath: NSIndexPath) -> CGRect
    
    // 获取临时用于显示图片的UIImageView对象
    func getImageView(indexPath: NSIndexPath) -> UIImageView
}

protocol XYAnimationDismissDelegate : NSObjectProtocol {
    
    // 获取消失的view的imageView
    func getImageViewForDismissView() -> UIImageView
    
    // 获取消失的viewindexPath
    func getIndexPathForDismissView() -> NSIndexPath
}

class XYPhotoBrowerAnimation: NSObject {

    var isPresented : Bool = false
    
    var presentedDelegate : XYAnimationPresentedDelegate?  // 弹出代理
    var dismissDelegate : XYAnimationDismissDelegate?      // 消失代理
    
    
    var indexPath : NSIndexPath?
    
    
}

extension XYPhotoBrowerAnimation: UIViewControllerTransitioningDelegate  {

    // 弹出动画代理
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    // 关闭动画代理
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension XYPhotoBrowerAnimation: UIViewControllerAnimatedTransitioning {
    
    // 设置动画事件
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        isPresented ? presentedAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
    
    
    /// 弹出动画
    func presentedAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 0.nil值校验
        guard let indexPath = indexPath, let presentedDelegate = presentedDelegate else {
            return
        }
        
        // 1.获取图片显示的原始frame和结束frame\获取imageView对象
        let starFrame = presentedDelegate.getStartFrame(indexPath: indexPath)
        let endFrame = presentedDelegate.getEndFrame(indexPath: indexPath)
        
        // 2.取出弹出的控制器view
        let presentedView = transitionContext.view(forKey: .to)
        let imageView = presentedDelegate.getImageView(indexPath: indexPath)
        // 3.将view添加到容器视图中
        transitionContext.containerView.addSubview(presentedView!)
        transitionContext.containerView.addSubview(imageView)
        
        // 4.将imageView添加到容器视图中
        // 5.设置动画
        presentedView?.alpha = 0.0
        imageView.frame = starFrame
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView .animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            imageView.frame = endFrame
        }) { (_) in
            imageView.removeFromSuperview()
            presentedView?.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    
    /// 消失动画
    func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 0.nil值校验
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        
        // 1.取出消失的控制器view，并将其从父控件中移除
        let dismissView = transitionContext.view(forKey: .from)
        dismissView?.removeFromSuperview()
        
        // 2.获取执行动画的imageView
        let imageView = dismissDelegate.getImageViewForDismissView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.getIndexPathForDismissView()
        
        // 3设置动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            imageView.frame = presentedDelegate.getStartFrame(indexPath: indexPath)
            }) { (_) in
                
            transitionContext.completeTransition(true) // 动画完毕后必须告知true，不然后出现假死
        }
        
    }
  
}
