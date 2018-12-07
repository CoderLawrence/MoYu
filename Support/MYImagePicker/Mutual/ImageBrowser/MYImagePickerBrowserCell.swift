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
    
    ///单击图片委托
    func onSingleTap(inView: MYImagePickerBrowserCell)
}

class MYImagePickerBrowserCell: UICollectionViewCell, UIScrollViewDelegate {
    
    ///图片获取ID
    private var requestId: PHImageRequestID = 0
    
    ///委托
    public weak var delegate:MYImagePickerBrowserCellDelegate?
    
    ///相册数据
    public var assetItem: MYImagePickerItemModel? {
        didSet {
            if let assetItem = assetItem {
                if let image = assetItem.thumbnailImage {
                    self.imageView.image = image
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
        self.addTapGestureRecognizers()
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
    
    //MARK: - 点击事件
    private func addTapGestureRecognizers() {
        let singleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(onSingleTap(sender:)))
        
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(onDoubleTap(sender:)))
        doubleTapGesture.numberOfTapsRequired = 2
        singleTapGesture.require(toFail: doubleTapGesture)
        
        self.scrollView.addGestureRecognizer(singleTapGesture)
        self.scrollView.addGestureRecognizer(doubleTapGesture)
    }
    
    //MARK: - 懒加载
    private lazy var imageView: UIImageView = {
        () -> UIImageView in
        let imageView = UIImageView(frame: self.scrollView.bounds);
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
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
        
        let imageW = image.size.width
        let imageH = image.size.height
        let imageViewW = self.imageView.width
        let imageViewH = self.imageView.height
        let contentViewW = self.contentView.width
        let contentViewH = self.contentView.height
        if imageH / imageW > contentViewH / contentViewW {
            self.imageView.height = CGFloat(floor(imageH / (imageW / imageViewW)))
            self.imageView.y = 0
        } else {
            var height = imageH / imageW * contentViewW
            if height < 1 || height.isNaN { height = contentViewH }
            self.imageView.height = CGFloat(floor(height))
            self.imageView.centerY = contentViewH / 2
        }
        
        if imageViewH > self.height && imageViewH - contentViewH <= 1 {
            self.imageView.height = self.height
        }
        
        let maxContentHeight = max(self.imageView.height, contentViewH)
        self.scrollView.contentSize = CGSize.init(width: self.width, height: maxContentHeight)
        self.scrollView.scrollRectToVisible(self.scrollView.bounds, animated: false)
        
        if self.imageView.height <= contentViewH {
            self.scrollView.alwaysBounceVertical = false
        } else {
            self.scrollView.alwaysBounceVertical = true
        }
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
    
    //MARK: - 事件点击
    @objc private func onSingleTap(sender: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.onSingleTap(inView: self)
        }
    }
    
    @objc private func onDoubleTap(sender: UITapGestureRecognizer) {
        if self.scrollView.zoomScale > 1.0 {
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.setZoomScale(1.0, animated: true)
        } else {
            let touchPoint = sender.location(in: self.imageView)
            let newZoomScale = self.scrollView.maximumZoomScale
            let xSize = self.width / newZoomScale
            let ySize = self.height / newZoomScale
            self.scrollView.zoom(to: CGRect.init(x: touchPoint.x - xSize/2, y: touchPoint.y - ySize/2, width: xSize, height: ySize), animated: true)
        }

    }
}
