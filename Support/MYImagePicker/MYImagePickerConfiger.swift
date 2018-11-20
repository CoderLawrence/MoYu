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
    
    ///是否需要相机
    public var isNeedCamera: Bool = true
    
    ///是否需要图片裁剪
    public var isNeedPhotoClip: Bool = false
    
    /// 最小选择图片数量
    public var minimumSelectedImageNum: Int = kMYImagePickerMinimumSelectedImageNum
    
    /// 最大选择图片数量
    public var maximumSelectedImageNum: Int = kMYImagePickerMinimumSelectedImageNum
    
    /// 默认初始化
    ///
    /// - Returns: 返回默认的图片选择器配置
    public class func defaultConfiger() -> MYImagePickerConfiger {
        return MYImagePickerConfiger();
    }
}
