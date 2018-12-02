//
//  MYImagePickerDetectingView.swift
//  MoYu
//  带点击检测视图
//  Created by Lawrence on 2018/12/2.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

protocol MYImagePickerDetectingViewDelegate: class {
    ///单击委托
    func singleTapDetected(view: MYImagePickerDetectingView, touch: UITouch)
    
    ///双击委托
    func doubleTapDetected(view: MYImagePickerDetectingView, touch: UITouch)
    
    ///三次点击
    func tripleTapDetected(view: MYImagePickerDetectingView, touch: UITouch)
}

class MYImagePickerDetectingView: UIView {
    
    ///委托
    public weak var delegate: MYImagePickerDetectingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
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
            delegate.singleTapDetected(view: self, touch: touch)
        }
    }
    
    private func handleDoubleTap(touch: UITouch) {
        if let delegate = self.delegate {
            delegate.doubleTapDetected(view: self, touch: touch)
        }
    }
    
    private func handleTripleTap(touch: UITouch) {
        if let delegate = self.delegate {
            delegate.tripleTapDetected(view: self, touch: touch)
        }
    }
}
