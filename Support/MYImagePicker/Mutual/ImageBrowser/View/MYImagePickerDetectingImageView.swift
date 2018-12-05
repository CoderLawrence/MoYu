//
//  MYImagePickerDetectingImageView.swift
//  MoYu
//  带点击检测图片视图
//  Created by Lawrence on 2018/12/2.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

protocol MYImagePickerDetectingImageViewDelegate: class {
    ///单击委托
    func singleTapDetected(imageView: MYImagePickerDetectingImageView, touch: UITouch)
    
    ///双击委托
    func doubleTapDetected(imageView: MYImagePickerDetectingImageView, touch: UITouch)
    
    ///三次点击
    func tripleTapDetected(imageView: MYImagePickerDetectingImageView, touch: UITouch)
}

class MYImagePickerDetectingImageView: UIImageView {
    ///委托
    public weak var delegate: MYImagePickerDetectingImageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.isUserInteractionEnabled = true
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch:UITouch = touches.first else { return }
        let tapCount: Int = touch.tapCount
        switch tapCount {
        case 1:
            self.handleSingleTap(touch: touch)
            break
        case 2:
            self.handleDoubleTap(touch: touch)
            break
        case 3:
            self.handleTripleTap(touch: touch)
            break
        default:
            break
        }
    }
    
    private func handleSingleTap(touch: UITouch) {
        if let delegate = self.delegate {
            delegate.singleTapDetected(imageView: self, touch: touch)
        }
    }
    
    private func handleDoubleTap(touch: UITouch) {
        if let delegate = self.delegate {
            delegate.doubleTapDetected(imageView: self, touch: touch)
        }
    }
    
    private func handleTripleTap(touch: UITouch) {
        if let delegate = self.delegate {
            delegate.tripleTapDetected(imageView: self, touch: touch)
        }
    }
}
