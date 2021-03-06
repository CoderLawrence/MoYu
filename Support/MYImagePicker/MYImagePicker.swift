//
//  MYImagePicker.swift
//  MoYu
//  相册入口
//  Created by Lawrence on 2018/11/17.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit
import Foundation

public protocol MYImagePickerDelegate: class {
    
    ///完成相册图片选择
    func didFinishSelectedImage(imagePicker: MYImagePicker, images:[MYImagePickerItemModel]?) -> Void
    
    ///取消相册选择
    func cancel(imagePicker: MYImagePicker, isCancel: Bool) -> Void
}

public final class MYImagePicker {
    
    /// 相册配置
    public var configer: MYImagePickerConfiger?
    
    /// 委托
    public var delegate: MYImagePickerDelegate?
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - delegate: 委托
    ///   - configer: 相册配置，可选参数
    public init(delegate: MYImagePickerDelegate,
                configer: MYImagePickerConfiger? = MYImagePickerConfiger.defaultConfiger())
    {
        self.configer = configer
        self.delegate = delegate
    }
    
    /// 显示相册
    ///
    /// - Parameter inViewController: 要显示相册的控制器
    public func show(_ inViewController: UIViewController) {
        
        //判断是否支持图片库
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false) { return }
        
        let imagePickerVC: MYImagePickerViewController = MYImagePickerViewController()
        
        //选择图片回调
        imagePickerVC.onFinishedCallBack = {[weak self] images in
            guard let `self` = self else { return }
            if let delegate = self.delegate {
                delegate.didFinishSelectedImage(imagePicker: self, images: images)
            }
        }
        
        //取消选择图片回调
        imagePickerVC.onCancelCallBack = {[weak self] isCancel in
            guard let `self` = self else { return }
            if let delegate = self.delegate {
                delegate.cancel(imagePicker: self, isCancel: isCancel)
            }
        }
        
        imagePickerVC.configer = self.configer
        let navigationController = MYImagePickerNavigationController.init(rootViewController: imagePickerVC)
        inViewController.present(navigationController, animated: true, completion: nil)
    }
}
