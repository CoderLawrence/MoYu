//
//  MYKeyFrameAnimationViewController.swift
//  MoYu
//
//  Created by Lawrence on 2018/12/29.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYKeyFrameAnimationViewController: UIViewController, CAAnimationDelegate {

    var animationButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        
        let button = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 32))
        button.addTarget(self, action: #selector(onButtonPress), for: UIControl.Event.touchUpInside)
        button.setTitle("动画", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.view.addSubview(button)
        
        let animationButton = UIButton.init(frame: CGRect.init(x: 100, y: 200, width: 100, height: 50))
        animationButton.addTarget(self, action: #selector(onAnimationPress), for: UIControl.Event.touchUpInside)
        animationButton.backgroundColor = UIColor.red
        self.view.addSubview(animationButton)
        self.animationButton = animationButton
    }
    
    @objc private func onButtonPress() {
        let transformAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        transformAnimation.toValue = Float.pi * 2
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = CAMediaTimingFillMode.forwards
        transformAnimation.duration = 2.0
        transformAnimation.delegate = self
        self.animationButton?.layer.add(transformAnimation, forKey: "transform")
        
        let postionAnim = CAKeyframeAnimation(keyPath: "position.y")
        postionAnim.values = [200, 600]
        postionAnim.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 2.0)]
//        postionAnim.fillMode = CAMediaTimingFillMode.forwards
//        postionAnim.isRemovedOnCompletion = false
        self.animationButton?.layer.add(postionAnim, forKey: "position")
    }
    
    @objc private func onAnimationPress() {
        print("onAnimationPress")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            
        }
    }
}
