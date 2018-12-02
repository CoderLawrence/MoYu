//
//  UIKit+Extension.swift
//  MoYu
//  UIKit相关拓展
//  Created by Lawrence on 2018/12/2.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    ///x
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        
        set {
            var tempFrame: CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    ///y
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        
        set {
            var tempFrame: CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    ///width
    var width: CGFloat {
        get {
            return frame.size.width
        }
        
        set {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    ///height
    var height: CGFloat {
        get {
            return frame.size.height
        }
        
        set {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    var centerX: CGFloat {
        get {
            return center.x
        }
        
        set {
            var tempCenter: CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    
    var centerY: CGFloat {
        get {
            return center.y
        }
        
        set {
            var tempCenter: CGPoint = center
            tempCenter.y = newValue
            center = tempCenter
        }
    }
}
