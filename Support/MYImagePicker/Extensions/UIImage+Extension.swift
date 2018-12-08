//
//  UIImage+Extension.swift
//  MoYu
//
//  Created by Lawrence on 2018/12/8.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    
    /// 图片预览器转场动画放回图片大小和位置
    ///
    /// - Returns: 大小和位置
    public func browserBackScreenImageViewRect() -> CGRect {
        let imageW = self.size.width
        let imageH = self.size.height
        let newSizeH = screenWidth / imageW * imageH
        var imageY = (screenHeight - newSizeH) * 0.5
        let newSize = CGSize.init(width: screenWidth, height: newSizeH)
        
        if imageY < 0 { imageY = 0 }
        return CGRect.init(x: 0, y: imageY, width: newSize.width, height: newSize.height)
    }
}
