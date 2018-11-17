//
//  MYImagePickerAlbumModel.swift
//  MoYu
//  相册结构体
//  Created by Lawrence on 2018/7/6.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import Foundation
import Photos

public class MYImagePickerAlbumModel {
    
    /// 相册名称
    public var name: String?
    /// 照片个数
    public var count: Int? = 0
    /// 线程原始数据
    public var data: PHFetchResult<AnyObject>?
    /// 相册标识
    public var identifier: String?
    /// 是否为相机胶卷
    public var isCameraRoll: Bool? = false
    /// 相册封面
    public var thumbnailImage: UIImage?
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - result: 相册数据
    ///   - name: 相册名称
    /// - Returns: 自定义相册结构体
    public class func album(result: PHFetchResult<AnyObject>, name: String, identifier: String, isCameraRoll: Bool) -> MYImagePickerAlbumModel {
        
        let album = MYImagePickerAlbumModel()
        album.name = name
        album.data = result
        album.count = result.count
        album.identifier = identifier
        album.isCameraRoll = isCameraRoll
        
        return album
    }
}
