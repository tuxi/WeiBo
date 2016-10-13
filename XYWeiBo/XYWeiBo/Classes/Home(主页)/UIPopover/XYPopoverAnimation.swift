//
//  XYPopoverAnimation.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/29.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYPopoverAnimation: NSObject {
    // MARK:- 属性
    var isPresented = false
    var presentedViewFrame = CGRect.zero
    
    var presentedCallBack : ((_ isPresented : Bool) -> ())?
    
    init(presentedCallBack : @escaping (_ isPresented : Bool) -> ()) {
        
        self.presentedCallBack = presentedCallBack
    }
}

// MARK:- 转场的代理方法 UIViewControllerTransitioningDelegate
extension XYPopoverAnimation : UIViewControllerTransitioningDelegate {
    
    // 目的:改变弹出view的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        // presented: 已经弹出的控制器XYWeiBo.XYPopoverViewController
        // presenting: nil
        // 需要自定义一个类，继承UIPresentationController类
        let presentationController = XYPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.presentedViewFrame = presentedViewFrame
        return presentationController
    }
    
    // 目的:自定义弹出的动画 --> 为弹出的控制器做动画
    // 返回值:返回某一个对象，这个对象必须遵守协议UIViewControllerAnimatedTransitioning
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // 记录动画已经弹出
        isPresented = true
        presentedCallBack!(isPresented) // 将动画的状态传递给闭包
        
        // 返回当前控制器，但是必须让当前控制器遵守UIViewControllerAnimatedTransitioning 协议
        return self
    }
    
    // 目的:自定义消失动画(遵守的协议和弹出动画的协议一样)
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 记录动画已经弹出
        isPresented = false
        presentedCallBack!(isPresented) // 将动画的状态传递给闭包
        return self
    }
}


// MARK:- 弹出和消失动画的代理方法 UIViewControllerAnimatedTransitioning
extension XYPopoverAnimation : UIViewControllerAnimatedTransitioning {
    
    // 动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // 获取【转场上下文】: 通过【转场上下文】获取弹出的view和消失的view
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 当动画弹出时执行自定义的弹出动画，当动画消失时执行自定义的消失动画
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
    }
}

// MARK:- 自定义弹出和消失的动画
extension XYPopoverAnimation {
    
    // 自定义弹出的动画
    func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
        
        // 1.获取弹出的view
        // UITransitionContextFromViewKey : 消失的view
        // UITransitionContextToViewKey   : 弹出的view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        // 2.将弹出的view添加到containerView容器视图中
        transitionContext.containerView.addSubview(presentedView!)
        
        // 3.执行动画
        presentedView?.transform = CGAffineTransform(scaleX: 1.0, y: 0)
        // 由于默认一个控件的锚点在0.5、0.5(即中心点)，这里更改为从titleView底部开始向下执行动画
        presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            presentedView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }) { (_) in
            // 必须告诉转场上下文，动画已经结束
            transitionContext.completeTransition(true)
            
        }
    }
    
    // 自定义消失的动画
    func animationForDismissView(_ transitionContext: UIViewControllerContextTransitioning) {
        
        // 1.获取消失的view
        let dismissView = transitionContext.view(forKey: .from)
        
        // 2.执行动画
        UIView .animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.001)
        }) { (_) in
            // 动画完成
            dismissView?.removeFromSuperview()
            // 告诉转场上下文动画已经结束
            transitionContext.completeTransition(true)
        }
        
    }
}
