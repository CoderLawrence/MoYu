//
//  MYImageBrowserView.swift
//  MoYu
//  图片预览器视图
//  Created by Lawrence on 2018/11/26.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

public let kMYBrowserPhotoMarginX: CGFloat = 8.0

private let imageBroswerIdentifier = "MYImagePickerBroswerCellIdentifier"

public typealias MYImagePickerBrowserSingleTapCallBack = () -> Void

class MYImagePickerBrowserView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, MYImagePickerBrowserCellDelegate {
    
    ///相册数据
    public var images:[MYImagePickerItemModel]? {
        didSet {
            if images != nil && images!.count > 0 {
                self.collectionView.reloadData()
            }
        }
    }
    
    ///单点图片回调
    public var singleTapCallBack: MYImagePickerBrowserSingleTapCallBack?
    
    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.collectionView.frame = self.frame
    }
    
    private func setupUI() {
        self.addSubview(self.collectionView)
    }
    
    //MARK: - 懒加载
    
    private lazy var layout: UICollectionViewFlowLayout = {
        () -> UICollectionViewFlowLayout in
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: kMYBrowserPhotoMarginX * 2, bottom: 0, right: 0)
        layout.itemSize = CGSize.init(width: self.width - kMYBrowserPhotoMarginX * 2, height: self.height)
        layout.minimumInteritemSpacing = kMYBrowserPhotoMarginX * 2
        layout.minimumLineSpacing = kMYBrowserPhotoMarginX * 2
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        () -> UICollectionView in
        let aView: UICollectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        aView.register(MYImagePickerBrowserCell.classForCoder(), forCellWithReuseIdentifier: imageBroswerIdentifier)
        aView.backgroundColor = UIColor(white: 0, alpha: 0)
        aView.showsVerticalScrollIndicator = false
        aView.showsHorizontalScrollIndicator = false
        aView.alwaysBounceHorizontal = true
        aView.alwaysBounceVertical = false
        aView.isPagingEnabled = true
        aView.scrollsToTop = false
        aView.dataSource = self
        aView.delegate = self
        
        if #available(iOS 11, *) {
            aView.contentInsetAdjustmentBehavior = .never
        }
        
        return aView
    }()
    
    //MARK: - 公开方法
    
    /// 滑动图片到指定索引
    ///
    /// - Parameter index: 对应要预览图片的索引
    public func scrollBrowserImage(forIndex index: Int) {
        guard let images = images, index < images.count else { return }
        let indexPath = IndexPath.init(row: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    //MARK: - UICollectionViewDelegate && UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (self.images != nil && self.images!.count > 0) {
            return 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.images != nil && self.images!.count > 0) {
            return self.images!.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MYImagePickerBrowserCell = collectionView.dequeueReusableCell(withReuseIdentifier: imageBroswerIdentifier, for: indexPath) as! MYImagePickerBrowserCell
        cell.assetItem = self.images![indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.isKind(of: MYImagePickerBrowserCell.classForCoder()) {
            let imageCell = cell as! MYImagePickerBrowserCell
            imageCell.recoverNormalSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.isKind(of: MYImagePickerBrowserCell.classForCoder()) {
            let imageCell = cell as! MYImagePickerBrowserCell
            imageCell.recoverNormalSize()
        }
    }
    
    //MARK: - MYImagePickerBrowserCellDelegate
    func onZoomImageView(isZoomIn: Bool) {
        self.collectionView.isScrollEnabled = !isZoomIn
    }
    
    func onSingleTap(inView: MYImagePickerBrowserCell) {
        if let callBack = self.singleTapCallBack {
            callBack()
        }
    }
}
