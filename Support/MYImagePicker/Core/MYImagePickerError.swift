//
//  MYImagePickerError.swift
//  MoYu
//  图片相册器错误处理信息
//  Created by Lawrence on 2018/7/26.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import Foundation

public enum MYImagePickerError: Error {
    
    public enum SaveImageFailed {
        case imageWasNil
        case saveImageFailed(error: Error)
    }
    
    case saveImageFailed(reason: SaveImageFailed)
}

extension MYImagePickerError.SaveImageFailed {
    var localizedDescription: String {
        switch self {
        case .imageWasNil:
            return "save image failure because of image was nil"
        case .saveImageFailed(let error):
            return "save image failure because of error\n\(error)"
        }
    }
}
