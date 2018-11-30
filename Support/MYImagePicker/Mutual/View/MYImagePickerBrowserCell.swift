//
//  MYImagePickerBrowserCell.swift
//  MoYu
//
//  Created by zengqingsong on 2018/11/30.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit
import Photos

class MYImagePickerBrowserCell: UICollectionViewCell {
    
    ///图片获取ID
    private var requestId: PHImageRequestID = 0
    
    ///相册数据
    public var assetItem: MYImagePickerItemModel? {
        willSet {
            if (newValue != nil) {
                if (newValue?.thumbnailImage != nil) {
                    self.imageView.image = newValue?.thumbnailImage
                } else {
                    self.requestImage()
                }
            }
        }
    }
    
    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.cancelRequestImage()
    }
    
    private func setupUI() {
        self.contentView.addSubview(self.imageView)
    }
    
    //MARK: - 懒加载
    private lazy var imageView: UIImageView = {
        () -> UIImageView in
        let frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let imageView = UIImageView(frame: frame);
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    //MARK: - 图片获取
    private func requestImage() {
        if let assetItem = self.assetItem {
            let requestId: PHImageRequestID = MYImagePickerManager.default.getAssetThumbnailImage(item: assetItem, width: self.frame.size.width) { (identifier, image) in
                
                if (identifier == assetItem.identifier && image != nil) {
                    self.imageView.image = image
                    self.assetItem?.thumbnailImage = image
                }
                
                self.requestId = 0
            }
            
            self.requestId = requestId
        }
    }
    
    private func cancelRequestImage() {
        if (self.requestId > 0) {
            MYImagePickerManager.default.cancelImageRequest(id: self.requestId)
            self.requestId = 0
        }
    }
}
