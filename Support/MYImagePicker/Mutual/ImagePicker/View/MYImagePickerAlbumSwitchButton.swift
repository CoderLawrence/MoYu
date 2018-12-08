//
//  MYImagePickerAlbumSwitchButton.swift
//  MoYu
//  相册切换按钮
//  Created by Lawrence on 2018/7/31.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

protocol MYImagePickerAlbumSwitchButtonDelegate: class {
    
    /// 切换相册
    ///
    /// - Parameters:
    ///   - switchButton: 按钮
    ///   - isSwitch: 切换/收起
    func didSwitchAlbum(switchButton: MYImagePickerAlbumSwitchButton, isSwitch: Bool)
}

class MYImagePickerAlbumSwitchButton: UIControl {
    
    // MARK: - setter && getter
    
    /// 标题
    public var title: String? {
        willSet {
            if (newValue != nil) {
                self.titleLabel.text = newValue
                self.layoutViews()
            }
        }
    }
    
    /// 标题颜色
    public var titleColor: UIColor? {
        willSet {
            if (newValue != nil) {
                self.titleLabel.textColor = newValue
            }
        }
    }
    
    /// 是否切换相册
    private var isSwitchAlbum: Bool = false
    
    /// 委托
    public weak var delegate: MYImagePickerAlbumSwitchButtonDelegate? = nil
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.addEvents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.arrowImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutViews()
    }
    
    // MARK: - lazy load
    
    /// 标题
    private lazy var titleLabel: UILabel = {
        () -> UILabel in
        
        let tempTitleLabel: UILabel = UILabel.init(frame: CGRect.zero)
        tempTitleLabel.textColor = UIColor.black
        tempTitleLabel.textAlignment = NSTextAlignment.center
        tempTitleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        tempTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        tempTitleLabel.numberOfLines = 1
        
        return tempTitleLabel
    }()
    
    /// 箭头
    private lazy var arrowImageView: UIImageView = {
        () -> UIImageView in
        
        let width: CGFloat = 13
        let height: CGFloat = 8
        let frame: CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        let tempImageView: UIImageView = UIImageView.init(frame: frame)
        tempImageView.image = UIImage(named: "MYImagePicker_Arrow")
        
        return tempImageView
    }()
    
    // MARK: - public func
    
    /// 收起相册
    public func packupAlbum() {
        self.dealAlbumSwitch()
    }
    
    // MARK: - private func
    
    private func layoutViews() {
        
        let width: CGFloat = self.frame.size.width
        let height: CGFloat = self.frame.size.height

        //标题
        let titleWidth: CGFloat = self.titleLabel.textWidth()
        let x: CGFloat = (width - titleWidth - self.arrowImageView.frame.size.width)/2
        
        let titleLabelFrame: CGRect = CGRect(x: x, y: 0, width: titleWidth, height: height)
        self.titleLabel.frame = titleLabelFrame
        
        //箭头
        var arrowImageFrame: CGRect = self.arrowImageView.frame
        let arrowImageHeight: CGFloat = arrowImageFrame.size.height/2
        arrowImageFrame.origin.y = titleLabelFrame.midY - arrowImageHeight
        arrowImageFrame.origin.x = (x + titleWidth + 5)
        self.arrowImageView.frame = arrowImageFrame
    }
    
    /// 处理相册切换逻辑
    private func dealAlbumSwitch() {
        if self.isSwitchAlbum {
            self.isSwitchAlbum = false
            if let delegate = self.delegate {
                delegate.didSwitchAlbum(switchButton: self, isSwitch: self.isSwitchAlbum)
            }
            
            UIView.animate(withDuration: 0.25) {
                self.arrowImageView.transform = CGAffineTransform.identity
            }
        } else {
            self.isSwitchAlbum = true
            if let delegate = self.delegate {
                delegate.didSwitchAlbum(switchButton: self, isSwitch: self.isSwitchAlbum)
            }
            
            UIView.animate(withDuration: 0.25) {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
            }
        }
    }
    
    /// 添加点击事件
    private func addEvents() {
        self.addTarget(self, action: #selector(onClick), for: UIControl.Event.touchUpInside)
    }
    
    // MARK: - action
    
    @objc private func onClick() {
        self.dealAlbumSwitch()
    }
}
