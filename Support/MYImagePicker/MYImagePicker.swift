//
//  MYImagePicker.swift
//  MoYu
//
//  Created by Lawrence on 2018/11/17.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import Foundation

public protocol MYImagePickerDelegate: class {
    
    ///完成相册图片选择
    func didFinishSelectedImage(images:[MYImagePickerItemModel]?) -> Void
    
    ///取消相册选择
    func cancel() -> Void
}
