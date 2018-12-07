//
//  MYImagePickerBrowserAnimator.swift
//  MoYu
//  图片预览器自定义转场动画
//  Created by zengqingsong on 2018/12/7.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerBrowserAnimator: NSObject {
    /// 判断当前动画是弹出还是消失
    public var isPresented: Bool = false
    
    public var animationDuration: TimeInterval = 0.5
}

extension MYImagePickerBrowserAnimator: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    //MARK: - UIViewControllerTransitioningDelegate && UIViewControllerAnimatedTransitioning
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
