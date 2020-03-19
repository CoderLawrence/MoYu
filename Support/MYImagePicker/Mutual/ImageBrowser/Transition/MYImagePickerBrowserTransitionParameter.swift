//
//  MYImagePickerBrowserTransitionParameter.swift
//  MoYu
//  图片预览器转场动画参数
//  Created by Lawrence on 2018/12/7.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerBrowserTransitionParameter {
    
    /// 转场过度图片
    public var transitionImage: UIImage? {
        didSet {
            guard let image = transitionImage else { return }
            toTransitionImageFrame = self.backScreenImageViewRect(image: image)
        }
    }
    
    /// 所浏览图片的下标
    public var transitionImageIndex: Int? {
        didSet {
            guard let index = transitionImageIndex,
                  let transitionImageFrames = transitionImageFrames else { return }
            guard index < transitionImageFrames.count else { return }
            fromTransitionImageFrame = transitionImageFrames[index].cgRectValue
        }
    }
    
    /// 图片选择器图片相对于屏幕所对应位置的大小集合
    public var transitionImageFrames: [NSValue]?
    
    /// 当前滑动时对应图片的frame
    public var currentPanGestureImageFrame: CGRect?
    
    /// 滑动返回手势
    public var panGestureRecognizer: UIPanGestureRecognizer?
    
    /// 转场前图片的大小和位置
    fileprivate(set) var fromTransitionImageFrame: CGRect?
    
    /// 转场后图片的大小和位置
    fileprivate(set) var toTransitionImageFrame: CGRect?
}

extension MYImagePickerBrowserTransitionParameter {
    
    /// 获取转场后图片的大小和位置
    ///
    /// - Parameter image: 图片
    /// - Returns: 图片大小和位置
    private func backScreenImageViewRect(image: UIImage) -> CGRect {
        let imageW = image.size.width
        let imageH = image.size.height
        let newSizeH = screenWidth / imageW * imageH
        var imageY = (screenHeight - newSizeH) * 0.5
        let newSize = CGSize.init(width: screenWidth, height: newSizeH)
        
        if imageY < 0 { imageY = 0 }
        return CGRect.init(x: 0, y: imageY, width: newSize.width, height: newSize.height)
    }
}
