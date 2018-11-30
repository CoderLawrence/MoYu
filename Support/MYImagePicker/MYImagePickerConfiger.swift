//
//  MYImagePickerConfiger.swift
//  MoYu
//  图片选择器配置
//  Created by zengqingsong on 2018/11/19.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit
import Foundation

/// 默认选择图片的最小值
let kMYImagePickerMinimumSelectedImageNum = 1

public class MYImagePickerConfiger {
    
    /// 完成按钮标题
    public var confirmButtonText: String?
    
    /// 取消按钮标题
    public var cancelButtonText: String?
    
    ///是否需要相机
    public var isNeedCamera: Bool = false
    
    ///是否需要图片裁剪
    public var isNeedPhotoClip: Bool = false
    
    /// 最小选择图片数量
    public var minimumSelectedImageNum: Int = 0
    
    /// 最大选择图片数量
    public var maximumSelectedImageNum: Int = 0
    
    /// 默认初始化
    ///
    /// - Returns: 返回默认的图片选择器配置
    public class func defaultConfiger() -> MYImagePickerConfiger {
        let configer = MYImagePickerConfiger()
        configer.isNeedCamera = true
        configer.isNeedPhotoClip = true
        configer.cancelButtonText = "取消"
        configer.confirmButtonText = "完成"
        configer.minimumSelectedImageNum = kMYImagePickerMinimumSelectedImageNum
        configer.maximumSelectedImageNum = kMYImagePickerMinimumSelectedImageNum
        
        return configer
    }
}
