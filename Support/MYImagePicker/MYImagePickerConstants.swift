//
//  MYImagePickerConstants.swift
//  MoYu
//  相关常量定义
//  Created by Lawrence on 2018/12/1.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit
import Foundation

///屏幕比例
let screenScale = UIScreen.main.scale

///屏幕宽度
let screenWidth = UIScreen.main.bounds.size.width

///屏幕高度
let screenHeight = UIScreen.main.bounds.size.height

///导航栏高度
let navigationBarHeight: CGFloat = 44

///状态栏高度
let statusBarHeight: CGFloat = isIPhoneXSeries ? 44 : 20

///状态栏+导航栏高度
let statusBarAndNavigationBarHeight = statusBarHeight + navigationBarHeight

///是否为iPhone X系列手机
let isIPhoneXSeries: Bool = {
    var isIPhoneXSeries: Bool = false
    
    //判断当前设备是否为iPhone
    if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone) {
        return isIPhoneXSeries
    }
    
    //判断是否有安全区域，通过安全区域来判断是否为iPhone X系列
    if #available(iOS 11, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0.0
    }
    
    return isIPhoneXSeries
}()

///iPhone X系列底部安全区域高度
let iphoneXSeriesBottom: CGFloat = {
    var bottom: CGFloat = 0.0
    if #available(iOS 11, *) {
        bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    }
    
    return bottom
}()
