//
//  MYImagePickerItemModel.swift
//  MoYu
//  照片数据结构体
//  Created by Lawrence on 2018/7/6.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit
import Photos

public class MYImagePickerItemModel {
    
    /// 照片原始数据
    public var data: PHAsset?
    
    /// 照片唯一标识
    public var identifier: String?
    
    /// 图片缩略图
    public var thumbnailImage: UIImage?
    
    /// 与屏幕分辨率相同图片
    public var fullScreenImage: UIImage? {
        get {
            return self.imageForFullScreen()
        }
    }
    
    /// 原图
    public var originImage: UIImage? {
        get {
            return self.imageForOrigin()
        }
    }
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - data: 原始照片数据
    ///   - identifier: 照片唯一标识
    /// - Returns: 封装的相册结构体
    public class func createItem(data: PHAsset, identifier: String) -> MYImagePickerItemModel {
        let item: MYImagePickerItemModel = MYImagePickerItemModel()
        item.data = data
        item.identifier = identifier
        
        return item
    }
}
