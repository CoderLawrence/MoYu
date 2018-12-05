//
//  MYImagePickerBrowserCell.swift
//  MoYu
//  图片预览cell
//  Created by zengqingsong on 2018/11/30.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit
import Photos

protocol MYImagePickerBrowserCellDelegate: class {
    ///图片放大委托
    func onZoomImageView(isZoomIn:Bool)
}

class MYImagePickerBrowserCell: UICollectionViewCell, UIScrollViewDelegate, MYImagePickerDetectingImageViewDelegate {
    
    ///图片获取ID
    private var requestId: PHImageRequestID = 0
    
    ///委托
    public weak var delegate:MYImagePickerBrowserCellDelegate?
    
    ///相册数据
    public var assetItem: MYImagePickerItemModel? {
        willSet {
            if (newValue != nil) {
                if (newValue?.thumbnailImage != nil) {
                    self.imageView.image = newValue?.thumbnailImage
                    self.adjustImageViewFrame()
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
        self.scrollView.contentSize = self.scrollView.size
    }
    
    private func setupUI() {
        self.scrollView.addSubview(self.imageView)
        self.contentView.addSubview(self.scrollView)
    }
    
    //MARK: - 懒加载
    private lazy var imageView: MYImagePickerDetectingImageView = {
        () -> MYImagePickerDetectingImageView in
        let imageView = MYImagePickerDetectingImageView(frame: self.scrollView.bounds);
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.delegate = self
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        () -> UIScrollView in
        let frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height)
        let scrollView: UIScrollView = UIScrollView.init(frame: frame)
        scrollView.backgroundColor = UIColor.clear
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isMultipleTouchEnabled = true
        scrollView.canCancelContentTouches = true
        scrollView.delaysContentTouches = false
        scrollView.alwaysBounceVertical = false
        scrollView.scrollsToTop = false
        scrollView.bouncesZoom = true
        scrollView.maximumZoomScale = 2.5
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        return scrollView
    }()
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.refreshImageViewCenter()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if let delegate = self.delegate {
            delegate.onZoomImageView(isZoomIn: scale > 1.0)
        }
    }
    
    //MARK: - MYImagePickerDetectingImageViewDelegate
    func singleTapDetected(imageView: MYImagePickerDetectingImageView, touch: UITouch) {
        
    }
    
    func doubleTapDetected(imageView: MYImagePickerDetectingImageView, touch: UITouch) {
        if self.scrollView.zoomScale > 1.0 {
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.setZoomScale(1.0, animated: true)
        } else {
            let touchPoint = touch.location(in: self.imageView)
            let newZoomScale = self.scrollView.maximumZoomScale
            let xSize = self.width / newZoomScale
            let ySize = self.height / newZoomScale
            self.scrollView.zoom(to: CGRect.init(x: touchPoint.x - xSize/2, y: touchPoint.y - ySize/2, width: xSize, height: ySize), animated: true)
        }
    }
    
    func tripleTapDetected(imageView: MYImagePickerDetectingImageView, touch: UITouch) {
        
    }
    
    //MARK: - 公开方法
    public func recoverNormalSize() {
        self.scrollView.setZoomScale(1.0, animated: false)
    }
    
    //MARK: - 私有方法
    private func refreshImageViewCenter() {
        let scrollViewWidth = self.scrollView.width
        let scrollViewHeight = self.scrollView.height
        let scrollViewContentWidth = self.scrollView.contentSize.width
        let scrollViewContentHeight = self.scrollView.contentSize.height
        let offsetX = (scrollViewWidth > scrollViewContentWidth) ? ((scrollViewWidth - scrollViewContentWidth) * 0.5) : 0.0
        let offsetY = (scrollViewHeight > scrollViewContentHeight) ? ((scrollViewHeight - scrollViewContentHeight) * 0.5) : 0.0
        self.imageView.center = CGPoint.init(x: scrollViewContentWidth * 0.5 + offsetX, y: scrollViewContentHeight * 0.5 + offsetY)
    }
    
    private func adjustImageViewFrame() {
        guard let image = self.imageView.image else { return }
        let size = image.size
        let isLongImage = size.height/size.width > 2
        let scrollViewFrame = self.scrollView.frame
        let viewHeight = size.height * scrollView.size.width / size.width
        let viewOffsetY = isLongImage ? 0 : (scrollViewFrame.size.height - viewHeight) / 2
        self.imageView.frame = CGRect.init(x: 0, y: viewOffsetY, width: scrollViewFrame.size.width, height: viewHeight)
        self.scrollView.contentSize = CGSize.init(width: scrollViewFrame.size.width, height: viewHeight)
    }
    
    //MARK: - 图片加载
    private func requestImage() {
        if let assetItem = self.assetItem {
            let requestId: PHImageRequestID = MYImagePickerManager.default.getAssetThumbnailImage(item: assetItem, width: self.frame.size.width) { (identifier, image) in
                
                if (identifier == assetItem.identifier && image != nil) {
                    self.imageView.image = image
                    self.assetItem?.thumbnailImage = image
                    self.adjustImageViewFrame()
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
