//
//  MYImagePickerBrowser.swift
//  MoYu
//  图片预览器
//  Created by zengqingsong on 2018/12/7.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit
import Foundation

class MYImagePickerBrowser {
    
    ///要预览图片数据
    public var images: [MYImagePickerItemModel]?
    
    /// 转场动画
    public var transitionAnimator: MYImagePickerBrowserAnimatedTranstition?
    
    /// 显示图片预览器
    ///
    /// - Parameters:
    ///   - inViewController: 展示图片预览器的页面
    ///   - imageView: 当前展示的图片
    public func show(inViewController: UIViewController) {
        let browserVC = MYImagePickerBrowserViewController()
        let navigationVC = MYImagePickerNavigationController.init(rootViewController: browserVC)
        navigationVC.transitioningDelegate = transitionAnimator
        browserVC.images = self.images
        inViewController.present(navigationVC, animated: true, completion: nil)
    }
}
