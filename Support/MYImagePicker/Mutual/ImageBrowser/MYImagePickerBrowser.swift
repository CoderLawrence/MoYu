//
//  MYImagePickerBrowser.swift
//  MoYu
//  图片预览器
//  Created by zengqingsong on 2018/12/7.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit
import Foundation

public final class MYImagePickerBrowser {
    
    ///要预览图片数据
    public var images: [MYImagePickerItemModel]?
    
    /// 显示图片预览器
    ///
    /// - Parameters:
    ///   - inViewController: 展示图片预览器的页面
    ///   - imageView: 当前展示的图片
    public func show(inViewController: UIViewController, imageView: UIImageView?) {
        let browserVC = MYImagePickerBrowserViewController()
        let navigationVC = MYImagePickerNavigationController.init(rootViewController: browserVC)
        browserVC.images = self.images
        inViewController.present(navigationVC, animated: true, completion: nil)
    }
}
