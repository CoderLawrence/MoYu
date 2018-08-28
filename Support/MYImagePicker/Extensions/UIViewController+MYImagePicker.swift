//
//  UIViewController+MYImagePicker.swift
//  MoYu
//  控制器辅助类
//  Created by Lawrence on 2018/8/4.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// 获取导航栏+状态栏高度
    ///
    /// - Returns: 导航栏+状态栏高度
    public func my_navigationAndStatusBarHeight() -> CGFloat {
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight: CGFloat = (self.navigationController?.navigationBar.frame.height)!
        let navigationAndStatusBarHeight: CGFloat = statusBarHeight + navigationBarHeight
        
        return navigationAndStatusBarHeight
    }
}
