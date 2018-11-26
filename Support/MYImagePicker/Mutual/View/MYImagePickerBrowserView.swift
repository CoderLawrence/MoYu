//
//  MYImageBrowserView.swift
//  MoYu
//  图片预览器视图
//  Created by Lawrence on 2018/11/26.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerBrowserView: UIView {
    
    public var images:[MYImagePickerItemModel]? = nil
    
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
    
    private lazy var collectionView: UICollectionView = {
        () -> UICollectionView in
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = self.frame.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let aView: UICollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        aView.backgroundColor = UIColor(white: 0, alpha: 0)
        aView.showsVerticalScrollIndicator = false
        aView.showsHorizontalScrollIndicator = false
        aView.alwaysBounceHorizontal = false
        aView.alwaysBounceVertical = true
        
        return aView
    }()
}
