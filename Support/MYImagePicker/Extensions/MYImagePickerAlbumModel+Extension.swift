//
//  MYImagePickerAlbumModel+Extension.swift
//  MoYu
//  相册辅助工具
//  Created by Lawrence on 2018/7/27.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import Foundation
import UIKit

extension MYImagePickerAlbumModel {
    
    /// 同步获取相册封面图片
    ///
    /// - Parameter handle: 图片
    public func asyncGetThumbnailImage(_ handle: @escaping (UIImage?) -> Swift.Void) {
        if (self.thumbnailImage != nil) {
            handle(self.thumbnailImage)
        }
        
        if self.data == nil { return }
        
        MYImagePickerManager.share().asyncGetAlbumThumbailImage(item: self, size: CGSize(width: 260, height: 260), thumbnailLength: 80) { (identifier, image) in
            if image != nil {
                handle(image)
                self.thumbnailImage = image
            }
        }
    }
    
    /// 获取某一个相册的图片数据
    ///
    /// - Parameters:
    ///   - album: 相册数据
    ///   - handle: 图片数据集合
    public func getAssetListForAlbum(_ handle: @escaping(Array<MYImagePickerItemModel>) -> Swift.Void) {
        MYImagePickerManager.share().getAssetListForAlbum(album: self, handle)
    }
}
