//
//  MYImagePickerItemModel+Extension.swift
//  MoYu
//  图片数据辅助工具
//  Created by Lawrence on 2018/7/27.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import Foundation
import UIKit

extension MYImagePickerItemModel {
    
    /// 根据大小获取图片
    ///
    /// - Parameter size: 限制大小
    /// - Returns: 图片
    public func imageForLimitSize(size: CGSize) -> UIImage? {
        return MYImagePickerManager.share().synchronusGetImageForLimitSize(item: self, limitSize: size)
    }
    
    /// 根据屏幕分辨率获取图片
    ///
    /// - Returns: 图片
    public func imageForFullScreen() -> UIImage? {
        return MYImagePickerManager.share().synchronousGetFullScreenImage(item: self)
    }
    
    /// 获取原图
    ///
    /// - Returns: 图片
    public func imageForOrigin() -> UIImage? {
        return MYImagePickerManager.share().synchronousGetOriginImage(item: self)
    }
    
    /// 根据大小获取图片，无方向限制
    ///
    /// - Parameter size: 限制大小
    /// - Returns: 图片
    public func imageForWithoutOrientaion(size: CGSize) -> UIImage? {
        return MYImagePickerManager.share().synchronusGetImageForWithoutOritentation(item: self, limitSize: size)
    }
}
