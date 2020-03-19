//
//  MYImagePickerManager.swift
//  MoYu
//  相册管理器
//  Created by Lawrence on 2018/7/6.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import Foundation
import Dispatch
import Photos
import UIKit

/// 授权状态枚举
public enum MYImagePickerAuthorizationStatus: Int {
    case notDetermined = 0
    case restricted
    case denied
    case authorized
}

public class MYImagePickerManager {
    
    /// 照片排序（YES表示升序，NO表示降序, 默认升序）
    public var isSortAscendingByModificationDate: Bool = true
    
    /// 单例方法
    public static let `default`: MYImagePickerManager = {
        return MYImagePickerManager()
    }()
    
    /// 方法重载
    private init() {
        self.isSortAscendingByModificationDate = true;
    }
    
    // MARK: - 授权相关&&相册辅助方法
    
    /// 获取相册授权状态
    public func authorizationStatus() -> MYImagePickerAuthorizationStatus {
        return MYImagePickerAuthorizationStatus(rawValue: PHPhotoLibrary.authorizationStatus().rawValue as Int)!
    }
    
    /// 是否拒绝访问相册
    public func hasDenied() -> Bool {
        if self.authorizationStatus() == MYImagePickerAuthorizationStatus.denied || self.authorizationStatus() == MYImagePickerAuthorizationStatus.restricted {
            return true
        }
        
        return false
    }
    
    /// 请求系统相册授权
    /// 异步获取
    /// - Parameter handle: 授权状态回调
    public func requestAuthorizationStatus(_ handle: @escaping (MYImagePickerAuthorizationStatus) -> Swift.Void) {
        DispatchQueue.global().async {
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    handle(self.authorizationStatus())
                }
            })
        }
    }
    
    /// 是否为相机胶卷
    ///
    /// - Parameter metadata: true or false
    public func isCameraRollAlbum(metadata: PHAssetCollection) -> Bool {
        if metadata.isKind(of: PHAssetCollection.classForCoder()) {
            //获取系统版本信息
            var versionString: String = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "")
            if versionString.count <= 1 {
                versionString.append("00")
            } else if versionString.count <= 2 {
                versionString.append("0")
            }
            
            //区分iOS 8.0.0 ~ 8.0.2系统版本，拍照后的图片会保存在最近添加中
            let version: Float = Float(versionString)!
            if version >= 800 && version <= 802 {
                return metadata.assetCollectionSubtype == PHAssetCollectionSubtype.smartAlbumRecentlyAdded
            } else {
                return metadata.assetCollectionSubtype == PHAssetCollectionSubtype.smartAlbumUserLibrary
            }
        }
        
        return false
    }
    
    /// 取消图片加载
    ///
    /// - Parameter id: 图片标识
    public func cancelImageRequest(id: PHImageRequestID) {
        PHImageManager.default().cancelImageRequest(id)
    }
    
    // MARK: - 获取相册数据
    
    /// 加载相册数据，不包括相机胶卷
    ///
    /// - Parameter handle: 相册数据
    public func getAlbumListWithCompletion(_ handle: @escaping ([MYImagePickerAlbumModel]) -> Swift.Void) {
        self.loadPHCollectionWithCompletion(isCameraRollOnly: false, handle)
    }
    
    /// 加载相册数据，包括相机胶卷
    ///
    /// - Parameter handle: 相册数据
    public func getCameraRollAlbumListWithCompletion(_ handle: @escaping ([MYImagePickerAlbumModel]) -> Swift.Void) {
        self.loadPHCollectionWithCompletion(isCameraRollOnly: true, handle)
    }
    
    /// 获取某一个相册的图片数据
    ///
    /// - Parameters:
    ///   - album: 相册数据
    ///   - handle: 图片数据集合
    public func getAssetListForAlbum(album: MYImagePickerAlbumModel, _ handle: @escaping ([MYImagePickerItemModel]) -> Swift.Void) {
        var assetList:[MYImagePickerItemModel] = []
        
        DispatchQueue.global(qos: .default).async {
            let result: PHFetchResult = album.data!
            
            result.enumerateObjects({ (data, start, stop) in
                let assetData: PHAsset = data as! PHAsset
                let item: MYImagePickerItemModel = MYImagePickerItemModel.createItem(data: assetData, identifier: assetData.localIdentifier)
                assetList.append(item)
            })
            
            DispatchQueue.main.sync {
                handle(assetList)
            }
        }
    }
    
    // MARK: - 异步获取图片
    
    /// 异步获取指定规格图片
    ///
    /// - Parameters:
    ///   - item: 数据
    ///   - width: 图片的宽度
    ///   - handle: 回调
    /// - Returns: 图片请求Id
    @discardableResult
    public func getAssetThumbnailImage(item: MYImagePickerItemModel, width: CGFloat, _ handle: @escaping (_ identifier: String?, _ image: UIImage?) -> Swift.Void) -> PHImageRequestID {
        
        // 获取图片的Id
        var requestId: PHImageRequestID = 0
        //判断图片数据是否存在
        guard item.data != nil else { return requestId}
        //校验数据是否正确
        guard (item.data?.isKind(of: PHAsset.classForCoder()))! else { return requestId }
        
        let identifier: String = item.identifier!
        let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.fast
         requestId = PHImageManager.default().requestImage(for: item.data!, targetSize: CGSize.init(width: width * 2, height: width * 2), contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, info) in
            let isDownload:Bool = (info![PHImageCancelledKey] == nil && info![PHImageErrorKey] == nil)
            if (image != nil && isDownload) {
                handle(identifier, image)
            }
        }
        
        return requestId
    }
    
    /// 异步获取相册封面
    ///
    /// - Parameters:
    ///   - item: 相册数据
    ///   - size: 限制大小
    ///   - thumbnailLength: 限制图片大小(字节)
    ///   - handle: 图片
    public func asyncGetAlbumThumbailImage(item: MYImagePickerAlbumModel, size: CGSize, thumbnailLength: CGFloat, _ handle: @escaping(_ identifier: String?, _ image: UIImage?) -> Swift.Void) {
        
        let identifier: String = item.identifier!
        let asset: PHAsset = item.data?.lastObject as! PHAsset
        let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
        
        DispatchQueue.global(qos: .default).async {
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image: UIImage?, info) in
                
                let isDownload:Bool = (info![PHImageCancelledKey] == nil && info![PHImageErrorKey] == nil)
                if (image != nil && isDownload) {
                    let scale: CGFloat = CGFloat((image?.size.height)! / thumbnailLength)
                    let thumbnailImage: UIImage = UIImage.init(cgImage: (image?.cgImage)!, scale: scale, orientation: UIImage.Orientation.up)
                    
                    DispatchQueue.main.async {
                        handle(identifier, thumbnailImage)
                    }
                }
            }
        }
    }
    
    /// 根据屏幕分辨率获取图片
    ///
    /// - Parameters:
    ///   - item: 图片数据
    ///   - handle: 回调
    /// - Returns: 图片请求Id
    @discardableResult
    public func getAssetFullScreenImage(item: MYImagePickerItemModel, _ handle: @escaping (_ identifier: String?, _ image: UIImage?) -> Swift.Void) -> PHImageRequestID {
        
        var requestId: PHImageRequestID = 0
        //判断图片数据是否存在
        guard item.data != nil else { return requestId }
        //校验数据是否正确
        guard (item.data?.isKind(of: PHAsset.classForCoder()))! else { return requestId }
        // 图片标识
        let identifier: String = item.identifier!
        
        let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
        
        //计算图片大小
        let multiple: CGFloat = screenScale
        let width: CGFloat = screenWidth
        let ratio: CGFloat = CGFloat((item.data?.pixelWidth)!/(item.data?.pixelHeight)!)
        let pixelWidth: CGFloat = width * multiple
        let pixelHeight: CGFloat = CGFloat(pixelWidth/ratio)
        
        requestId = PHImageManager.default().requestImage(for: item.data!, targetSize: CGSize.init(width: pixelWidth, height: pixelHeight), contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, info) in
            let isDownload: Bool = (info![PHImageCancelledKey] == nil && info![PHImageErrorKey] == nil)
            if (image != nil && isDownload) {
                handle(identifier, image)
            }
        })
        
        return requestId
    }
    
    // MARK: - 同步获取图片
    
    /// 根据屏幕分辨率获取图片，同步获取
    ///
    /// - Parameter item: 原始图片数据
    /// - Returns: 图片数据
    /// - Throws: 获取错误异常
    public func synchronousGetFullScreenImage(item: MYImagePickerItemModel) -> UIImage? {
        let scale: CGFloat = screenScale
        let width: CGFloat = CGFloat(screenWidth * scale)
        let height: CGFloat = CGFloat(screenHeight * scale)
        return self.synchronusGetImageForTargetSize(item: item, targetSize: CGSize(width: width, height: height))
    }
    
    /// 根据图片数据获取原图，同步获取
    ///
    /// - Parameter item: 图片原始数据
    /// - Returns: 图片
    public func synchronousGetOriginImage(item: MYImagePickerItemModel) -> UIImage? {
        return self.synchronusGetImageForTargetSize(item: item, targetSize: PHImageManagerMaximumSize)
    }
    
    /// 根据图片数据获取限制大小图片，方向无限制，同步获取
    ///
    /// - Parameters:
    ///   - item: 图片数据
    ///   - limitSize: 限制大小
    /// - Returns: 图片
    @discardableResult
    public func synchronusGetImageForWithoutOritentation(item: MYImagePickerItemModel, limitSize: CGSize) -> UIImage? {
        var size: CGSize = limitSize
        let data: PHAsset = item.data!
        let isImageWidthLonger: Bool = Bool(data.pixelWidth > data.pixelHeight)
        let isSizeWidthLonger: Bool = Bool(size.width > size.height)
        
        if isImageWidthLonger != isSizeWidthLonger {
            size = CGSize(width: size.height, height: size.width)
        }
        
        return self.synchronusGetImageForTargetSize(item:item, targetSize:size)
    }
    
    /// 根据图片数据获取图片，同时满足宽高比，等比例缩放
    ///
    /// - Parameters:
    ///   - item: 原始图片数据
    ///   - size: 大小
    /// - Returns: 图片数据
    @discardableResult
    public func synchronusGetImageForLimitSize(item: MYImagePickerItemModel, limitSize: CGSize) -> UIImage? {
        
        //计算图片大小
        var size: CGSize = limitSize
        let assetData: PHAsset = item.data!
        if (assetData.pixelWidth > Int(limitSize.width) || assetData.pixelHeight > Int(limitSize.height)) {
            let originWidth: CGFloat = CGFloat(assetData.pixelWidth)
            let orginHeight: CGFloat = CGFloat(assetData.pixelHeight)
            let retio: CGFloat = min(limitSize.width/originWidth, size.height/orginHeight)
            let width: CGFloat = CGFloat(originWidth * retio)
            let height: CGFloat = CGFloat(orginHeight * retio)
            size = CGSize(width: width, height: height)
        } else {
            size = PHImageManagerMaximumSize
        }
        
        return self.synchronusGetImageForTargetSize(item: item, targetSize: size)
    }
    
    /// 根据大小获取图片
    ///
    /// - Parameters:
    ///   - item: 图片原始数据
    ///   - targetSize: 大小 无比例限制
    /// - Returns: 图片数据
    @discardableResult
    public func synchronusGetImageForTargetSize(item: MYImagePickerItemModel, targetSize: CGSize) -> UIImage? {
        
        var originImage: UIImage? = nil
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        var iCloudLoading: Bool = false
        
        // 有些图片存储在iCloud所以要判断图片是否下载完成
        requestOptions.progressHandler = {(progress, error, stop, info) in
            if !iCloudLoading {
                // 提示
            }
            
            iCloudLoading = true
        }
        
        PHImageManager.default().requestImage(for: item.data!, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, info) in
            //判断图片是否已经下载到本地，图片可能在iCloud
            let isDownload: Bool = (info![PHImageCancelledKey] == nil && info![PHImageErrorKey] == nil)
            if (image != nil && isDownload) {
                originImage = image
            }
        }
        
        return originImage
    }
    
    // MARK: - 保存图片
    
    /// 保存图片到相册
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - handle: 回调
    public func saveImage(image: UIImage?, _ handle: @escaping (_ isSuccess: Bool, _ error: MYImagePickerError?) -> Swift.Void) {
        if (image == nil) {
            handle(false, MYImagePickerError.saveImageFailed(reason: .imageWasNil))
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let data: Data = image!.jpegData(compressionQuality: 0.9)!
            if #available(iOS 9.0, *) {
                let requestOptions: PHAssetResourceCreationOptions = PHAssetResourceCreationOptions()
                let request:PHAssetCreationRequest = PHAssetCreationRequest()
                request.addResource(with: PHAssetResourceType.photo, data: data, options: requestOptions)
                request.creationDate = Date()
            } else {
                let request: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image!)
                request.creationDate = Date()
            }
        }) { (isSuccess, error) in
            DispatchQueue.main.sync {
                if isSuccess {
                    handle(isSuccess, nil)
                    return
                }
                
                if (error != nil) {
                    handle(isSuccess, MYImagePickerError.saveImageFailed(reason: .saveImageFailed(error: error!)))
                }
            }
        }
    }
    
    // MARK: - 私有方法
    
    /// 加载相册数据
    ///
    /// - Parameters:
    ///   - isCameraRollOnly: 是否只是加载相机胶卷
    ///   - handle: 回调
    private func loadPHCollectionWithCompletion(isCameraRollOnly: Bool, _ handle: @escaping ([MYImagePickerAlbumModel]) -> Swift.Void) {
        
        var albumList: [MYImagePickerAlbumModel] = []
        
        // 相册排序问题
        let predicate: NSPredicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let option: PHFetchOptions = PHFetchOptions()
        option.predicate = predicate;
        
        if self.isSortAscendingByModificationDate == true {
            option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: self.isSortAscendingByModificationDate)]
        }
        
        //获取相册数据
        let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        
        for i in 0..<smartAlbums.count {
            let collection: PHAssetCollection = smartAlbums[i]
            
            //过滤非PHAssetCollection对象
            if !collection.isKind(of: PHAssetCollection.classForCoder()) { continue }
            
            //判断是否为相机胶卷
            if self.isCameraRollAlbum(metadata: collection) {
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: option)
                let identifier = collection.localIdentifier;
                
                if fetchResult.count > 0 {
                    let albumModel: MYImagePickerAlbumModel = MYImagePickerAlbumModel.album(result: fetchResult as! PHFetchResult<AnyObject>, name: collection.localizedTitle!, identifier: identifier, isCameraRoll: true)
                    albumList.append(albumModel)
                }
            }
        }
        
        //加载所有相册数据
        if isCameraRollOnly == false {
            for i in 0..<smartAlbums.count {
                let collection: PHAssetCollection = smartAlbums[i]
                
                //过滤非PHAssetCollection对象
                if !collection.isKind(of: PHAssetCollection.classForCoder()) { continue }
                
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: option)
                let identifier = collection.localIdentifier;
                
                if fetchResult.count < 1 { continue }
                
                if self.isCameraRollAlbum(metadata: collection) == false {
                    let albumModel: MYImagePickerAlbumModel = MYImagePickerAlbumModel.album(result: fetchResult as! PHFetchResult<AnyObject>, name: collection.localizedTitle!, identifier: identifier, isCameraRoll: false)
                    albumList.append(albumModel)
                }
            }
        }
        
        //回调数据
        handle(albumList)
    }
}
