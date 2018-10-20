//
//  MYImagePickerCell.swift
//  MoYu
//  图片项视图
//  Created by Lawrence on 2018/7/30.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit
import Photos

let kMYImagePickerCellReuseIdentifier: String = "kMYImagePickerCellReuseIdentifier"

class MYImagePickerCell: UICollectionViewCell, MYImagePickerSubViewModelDelegate {
    
    /// cell 间隙
    static let itemSpace: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.contentView.addSubview(self.imageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.viewModel.cancelImageRequest()
        self.viewModel.assetItem = nil
    }
    
    // MARK: - lazy load
    
    lazy var viewModel: MYImagePickerSubViewModel = {
       () -> MYImagePickerSubViewModel in
        let viewModel: MYImagePickerSubViewModel = MYImagePickerSubViewModel()
        viewModel.delegate = self
        
        return viewModel
    }()
    
    lazy var imageView: UIImageView = {
       () -> UIImageView in
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        
        if (self.viewModel.thumbanilImage != nil) {
            imageView.image = self.viewModel.thumbanilImage
        }
        
        return imageView
    }()
    
    // MARK: - public func
    
    public func setAssetItem(item: MYImagePickerItemModel) {
        self.viewModel.assetItem = item
        self.viewModel.requestThumbanilImage(width: self.frame.size.width)
    }
    
    // MARK: - MYImagePickerSubViewModelDelegate
    
    func didFinishRequestImage(viewModel: MYImagePickerSubViewModel, image: UIImage?) {
        if image != nil {
            self.imageView.image = image
        }
    }
}
