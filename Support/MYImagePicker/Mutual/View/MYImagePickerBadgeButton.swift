//
//  MYImagePickerBadgeButton.swift
//  MoYu
//  带有数字标记的按钮
//  Created by Lawrence on 2018/7/31.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

fileprivate let defaultBorderWidth: Float = 1
fileprivate let badgeNumberLabelFontSize: CGFloat = 15.0

class MYImagePickerBadgeButton: UIControl {
    
    //MARK: - getter && setter
    
    /// 角标数字
    public var badgeNumber: Int = 0 {
        willSet {
            self.badgeNumberLabel.text = "\(newValue)"
        }
    }
    
    public var isSelectedImage: Bool = false {
        willSet {
            if newValue == true {
                self.badgeNumberLabel.isHidden = false
                self.backgroundColor = self.selectedBackgroundColor
            } else {
                self.badgeNumberLabel.isHidden = true
                self.backgroundColor = self.defaultBackgroundColor
            }
        }
    }
    
    /// 边框线条宽度
    public var borderWidth: Float = defaultBorderWidth {
        willSet {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    /// 边框颜色
    public var borderColor: UIColor = UIColor.white {
        willSet {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    ///选中背景颜色
    public var selectedBackgroundColor: UIColor = UIColor.red
    
    ///默认背景颜色
    public var defaultBackgroundColor: UIColor = UIColor.init(white: 0, alpha: 0.3)
    
    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.height/2
        self.backgroundColor = self.defaultBackgroundColor
        self.addSubview(self.badgeNumberLabel)
    }
    
    public lazy var badgeNumberLabel: UILabel = {
        () -> UILabel in
        let aLabel = UILabel(frame: self.bounds)
        aLabel.layer.cornerRadius = self.frame.size.height/2
        aLabel.font = UIFont.systemFont(ofSize: badgeNumberLabelFontSize)
        aLabel.textAlignment = NSTextAlignment.center
        aLabel.text = "\(self.badgeNumber)"
        aLabel.textColor = UIColor.white
        aLabel.isHidden = true
        
        return aLabel
    }()
}
