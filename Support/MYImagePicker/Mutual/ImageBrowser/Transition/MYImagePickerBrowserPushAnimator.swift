//
//  MYImagePickerBrowserPushAnimator.swift
//  MoYu
//  图片预览器转场动画进入动画
//  Created by Lawrence on 2018/12/8.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerBrowserPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 转场动画参数
    public var transitionParameter: MYImagePickerBrowserTransitionParameter?
    
    //MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let parameter = transitionParameter else { return}
        guard let index = parameter.transitionImageIndex,
              let transitionImage = parameter.transitionImage,
              let toTransitionImageFrame = parameter.toTransitionImageFrame,
              let transitionImageFrames = parameter.transitionImageFrames else { return }
        
        let containerView: UIView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        toViewController.view.isHidden = true
        containerView.addSubview(toViewController.view)
        
        //图片背景白色的空白视图
        let imageBackgroundFrame: CGRect = transitionImageFrames[index].cgRectValue
        let imageBackgroundWhiteView: UIView = UIView.init(frame: imageBackgroundFrame)
        imageBackgroundWhiteView.backgroundColor = UIColor.white
        containerView.addSubview(imageBackgroundWhiteView)
        
        //有渐变的黑色背景视图
        let backgroundView: UIView = UIView.init(frame: containerView.bounds)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0
        containerView.addSubview(backgroundView)
        
        //过度的图片
        let transitionImageView: UIImageView = UIImageView.init(image: transitionImage)
        transitionImageView.frame = transitionImageFrames[index].cgRectValue
        containerView.addSubview(transitionImageView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            transitionImageView.frame = toTransitionImageFrame
            backgroundView.alpha = 1
        }) { (finished) in
            toViewController.view.isHidden = false
            imageBackgroundWhiteView.removeFromSuperview()
            backgroundView.removeFromSuperview()
            transitionImageView.removeFromSuperview()
            //通知转场动画完毕
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
