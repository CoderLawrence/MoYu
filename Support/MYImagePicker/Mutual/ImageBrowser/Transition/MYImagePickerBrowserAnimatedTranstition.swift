//
//  MYImagePickerBrowserTranstitionAnimator.swift
//  MoYu
//  图片预览器转场动画
//  Created by Lawrence on 2018/12/8.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerBrowserAnimatedTranstition: NSObject, UIViewControllerTransitioningDelegate {
    
    /// 转场动画参数
    public var transitionParameter: MYImagePickerBrowserTransitionParameter? {
        didSet {
            if let parameter = transitionParameter {
                self.customPopAnimator.transitionParameter = parameter
                self.customPushAnimator.transitionParameter = parameter
            }
        }
    }
    
    /// 进入转场动画
    private lazy var customPushAnimator: MYImagePickerBrowserPushAnimator = {
        () -> MYImagePickerBrowserPushAnimator in
        let animator = MYImagePickerBrowserPushAnimator()
        return animator
    }()
    
    /// 消失转场动画
    private lazy var customPopAnimator: MYImagePickerBrowserPopAnimator = {
        () -> MYImagePickerBrowserPopAnimator in
        let animator = MYImagePickerBrowserPopAnimator()
        return animator
    }()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.customPushAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.customPopAnimator
    }
}
