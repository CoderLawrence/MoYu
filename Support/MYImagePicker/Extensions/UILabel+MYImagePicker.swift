//
//  UILabel+MYImagePicker.swift
//  MoYu
//  UILabel 拓展
//  Created by Lawrence on 2018/8/1.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    /// 获取文字宽度
    ///
    /// - Returns: 文字宽度
    public func textWidth() -> CGFloat {
        var stringWidth: CGFloat = 0
        let size = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        
        if ((self.text?.count)! > 0) {
            stringWidth = (self.text?.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: nil).width)!
        }
        
        return stringWidth
    }
}
