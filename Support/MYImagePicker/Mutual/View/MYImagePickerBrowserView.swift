//
//  MYImageBrowserView.swift
//  MoYu
//  图片预览器视图
//  Created by Lawrence on 2018/11/26.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

fileprivate let imageBroswerIdentifier = "MYImagePickerBroswerCellIdentifier"

class MYImagePickerBrowserView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var images:[MYImagePickerItemModel]? {
        willSet {
            if (newValue != nil && newValue!.count > 0) {
                self.collectionView.reloadData()
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
    
    override func layoutSubviews() {
        self.collectionView.frame = self.frame
    }
    
    private func setupUI() {
        self.addSubview(self.collectionView)
    }
    
    //MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        () -> UICollectionView in
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = self.frame.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let aView: UICollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
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
}
