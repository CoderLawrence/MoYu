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

protocol MYImagePickerCellDelegate: class {
    
    /// 是否可以继续选择图片
    ///
    /// - Parameter imagePickerCell: MYImagePickerCell
    /// - Returns: 根据配置返回是否可以选择图片
    func canSelectImage(imagePickerCell: MYImagePickerCell) -> Bool
    
    /// 选中图片角标
    ///
    /// - Parameter imagePickerCell: MYImagePickerCell
    /// - Returns: 返回选中图片的角标
    func onSelectedImageBadgeNumber(imagePickerCell: MYImagePickerCell) -> Int
    
    /// 选择\取消图片
    ///
    /// - Parameters:
    ///   - imagePickerCell: MYImagePickerCell
    ///   - assetItem: 选中图片数据
    ///   - isSelected: 选中\取消（true or false）
    func onClickSelectedImage(imagePickerCell: MYImagePickerCell, assetItem: MYImagePickerItemModel, isSelected: Bool)
}

class MYImagePickerCell: UICollectionViewCell, MYImagePickerSubViewModelDelegate {
    
    /// cell 间隙
    static let itemSpace: CGFloat = 5
    
    ///是否已经选中该图片
    public var isSelectedImage: Bool = false
    
    ///图片原始数据
    public var assetItem: MYImagePickerItemModel?
    
    /// 委托
    public weak var delegate: MYImagePickerCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.selectedBadgeButton)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.selectedBadgeButton.isSelectedImage = false
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
    
    lazy var selectedBadgeButton: MYImagePickerBadgeButton = {
        () -> MYImagePickerBadgeButton in
        let aButton = MYImagePickerBadgeButton.init(frame: CGRect(x: self.frame.size.width - 25 - 5, y: 5, width: 25, height: 25))
        aButton .addTarget(self, action: #selector(onBadgeButtonClick), for: UIControl.Event.touchUpInside)
        aButton.selectedBackgroundColor = UIColor.red
        aButton.borderColor = UIColor.white
        return aButton
    }()
    
    // MARK: - public func
    
    public func setAssetItem(item: MYImagePickerItemModel) {
        self.assetItem = item
        self.viewModel.assetItem = item
        self.viewModel.requestThumbanilImage(width: self.frame.size.width)
    }
    
    // MARK: - MYImagePickerSubViewModelDelegate
    
    func didFinishRequestImage(viewModel: MYImagePickerSubViewModel, image: UIImage?) {
        if image != nil {
            self.imageView.image = image
        }
    }
    
    //MARK: - 事件点击
    @objc private func onBadgeButtonClick(sender: MYImagePickerBadgeButton) {
        guard let assetItem = self.assetItem else { return }
        if let delegate = self.delegate {
            if (self.isSelectedImage == true) {
                self.isSelectedImage = false
                sender.isSelectedImage = false
                delegate.onClickSelectedImage(imagePickerCell: self, assetItem: assetItem, isSelected: false)
            } else {
                let canSelectImage: Bool = delegate.canSelectImage(imagePickerCell: self)
                if (canSelectImage == true) {
                    let badgeNumber: Int = delegate.onSelectedImageBadgeNumber(imagePickerCell: self)
                    sender.badgeNumber = badgeNumber
                    sender.isSelectedImage = true
                    self.isSelectedImage = true
                    delegate.onClickSelectedImage(imagePickerCell: self, assetItem: assetItem, isSelected: true)
                }
            }
        }
    }
}
