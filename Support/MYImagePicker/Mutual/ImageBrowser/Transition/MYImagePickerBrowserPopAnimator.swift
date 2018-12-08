//
//  MYImagePickerBrowserPopAnimator.swift
//  MoYu
//  图片预览器转场动画退出动画
//  Created by Lawrence on 2018/12/8.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerBrowserPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 转场动画参数
    public var transitionParameter: MYImagePickerBrowserTransitionParameter?
    
    //MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let parameter = transitionParameter else { return}
        guard let index = parameter.transitionImageIndex,
              let transitionImage = parameter.transitionImage,
              let toTransitionImageFrame = parameter.toTransitionImageFrame,
              let transitionImageFrames = parameter.transitionImageFrames else { return }
        
        let containerView: UIView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        containerView.addSubview(toViewController.view)
    
        //图片背景白色的空白视图
        let imageBackgroundFrame: CGRect = transitionImageFrames[index].cgRectValue
        let imageBackgroundWhiteView: UIView = UIView.init(frame: imageBackgroundFrame)
        imageBackgroundWhiteView.backgroundColor = UIColor.white
        containerView.addSubview(imageBackgroundWhiteView)
        
        //有渐变的黑色背景视图
        let backgroundView: UIView = UIView.init(frame: containerView.bounds)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 1
        containerView.addSubview(backgroundView)
        
        //过度的图片
        let transitionImageView: UIImageView = UIImageView.init(image: transitionImage)
        transitionImageView.contentMode = UIView.ContentMode.scaleAspectFill
        transitionImageView.clipsToBounds = true
        transitionImageView.frame = toTransitionImageFrame
        containerView.addSubview(transitionImageView)
        
        let toFrame: CGRect = transitionImageFrames[index].cgRectValue
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: UIView.AnimationOptions.curveLinear, animations: {
            var imageFrame = toFrame
            if imageFrame.size.width == 0 && imageFrame.size.height == 0 {
                let defaultWidth: CGFloat = 5.0
                imageFrame = CGRect.init(x: (screenWidth - defaultWidth) * 0.5, y: (screenHeight - defaultWidth) * 0.5, width: defaultWidth, height: defaultWidth)
            }
            
            transitionImageView.frame = imageFrame
            backgroundView.alpha = 0
        }) { (finished) in
            backgroundView.removeFromSuperview()
            imageBackgroundWhiteView.removeFromSuperview()
            transitionImageView.removeFromSuperview()
            //通知转场动画完毕
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
