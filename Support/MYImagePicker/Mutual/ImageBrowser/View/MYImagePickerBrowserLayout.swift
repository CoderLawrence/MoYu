//
//  MYImagePickerBrowserLayout.swift
//  MoYu
//  图片预览器布局
//  Created by Lawrence on 2018/12/5.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerBrowserLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        self.minimumLineSpacing = 0.0
        self.minimumInteritemSpacing = 0.0
        self.scrollDirection = UICollectionView.ScrollDirection.horizontal
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        let originArray: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) ?? []
        let copyArray: [UICollectionViewLayoutAttributes] = originArray.map {$0.copy() as! UICollectionViewLayoutAttributes}
        
        let centerX = collectionView.contentOffset.x + collectionView.width * 0.5
        for i in 0..<copyArray.count {
            let layoutAttributes = copyArray[i]
            let space = abs(layoutAttributes.center.x - centerX)
            let scale = 1 - space / collectionView.width
            layoutAttributes.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }
        
        return copyArray
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else { return .zero }
        let rect = CGRect.init(x: proposedContentOffset.x, y: 0, width: collectionView.width, height: collectionView.height)
        let layoutAttributes: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) ?? []
        let centerX = proposedContentOffset.x + collectionView.width * 0.5
        var minSpace:CGFloat = CGFloat(MAXFLOAT)
        for i in 0..<layoutAttributes.count {
            let layoutAttribute = layoutAttributes[i]
            if (abs(minSpace) > abs(layoutAttribute.center.x - centerX)) {
                minSpace = layoutAttribute.center.x - centerX
            }
        }
        
        return CGPoint.init(x: proposedContentOffset.x + minSpace, y: proposedContentOffset.y)
    }
}
