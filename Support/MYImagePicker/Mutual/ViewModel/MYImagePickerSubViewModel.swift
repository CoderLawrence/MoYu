//
//  MYImagePickerSubViewModel.swift
//  MoYu
//  图片项视图 view model
//  Created by Lawrence on 2018/7/31.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit
import Photos

protocol MYImagePickerSubViewModelDelegate: NSObjectProtocol {
    
    /// 图片请求完成
    ///
    /// - Parameters:
    ///   - image: 图片
    func didFinishRequestImage(viewModel: MYImagePickerSubViewModel, image: UIImage?)
}

class MYImagePickerSubViewModel: NSObject {
    
    /// 图片标识
    private var identifier: String? = nil
    
    /// 是否真正请求图片
    private var isRequesting: Bool = false
    
    /// 图片请求ID
    private var requestId: PHImageRequestID = PHInvalidImageRequestID
    
    /// 委托
    public weak var delegate: MYImagePickerSubViewModelDelegate? = nil
    
    // MARK: - getter && setter
    
    public var assetItem: MYImagePickerItemModel? {
        willSet {
            if (newValue != nil) {
                self.identifier = newValue?.identifier
            }
        }
    }
    
    public var thumbanilImage: UIImage? {
        get {
            if self.assetItem != nil && self.assetItem?.thumbnailImage != nil {
                return self.assetItem?.thumbnailImage
            }
            
            return nil
        }
    }
    
    // MARK: - init
    
    override init() {
        super.init()
    }
    
    // MARK: - public func
    
    /// 取消图片加载
    public func cancelImageRequest() {
        if self.isRequesting {
            MYImagePickerManager.share().cancelImageRequest(id: self.requestId)
        }
    }
    
    /// 图片系统图片
    public func requestThumbanilImage(width: CGFloat) {
        if (self.assetItem == nil) { return }
        
        if (self.assetItem?.thumbnailImage != nil && self.delegate != nil) {
            self.delegate?.didFinishRequestImage(viewModel: self, image: self.assetItem?.thumbnailImage)
            return
        }
        
        self.isRequesting = true
        let requestId: PHImageRequestID = MYImagePickerManager.share().getAssetThumbnailImage(item: self.assetItem!, width: width) { (identifier, image) in
            
            self.isRequesting = false
            if (identifier == self.identifier && image != nil) {
                self.assetItem?.thumbnailImage = image
                
                if (self.delegate != nil) {
                    self.delegate?.didFinishRequestImage(viewModel: self, image: image!)
                }
            }
            
            self.requestId = PHInvalidImageRequestID
        }
        
        self.requestId = requestId
    }
}