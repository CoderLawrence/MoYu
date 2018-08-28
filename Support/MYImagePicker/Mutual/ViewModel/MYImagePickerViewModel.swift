//
//  MYImagePickerViewModel.swift
//  MoYu
//  相册View Model
//  Created by Lawrence on 2018/7/28.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

protocol MYImagePickerViewModelDelegate: NSObjectProtocol {
    func didFinishLoadAlbumList(_ viewModel: MYImagePickerViewModel, _ list:Array<MYImagePickerAlbumModel>?)
    
    func didFinishLoadAssetList(_ viewModel: MYImagePickerViewModel, _ list: Array<MYImagePickerItemModel>?)
}

class MYImagePickerViewModel: NSObject {
    
    /// 系统相册列表
    public var albumList:Array<MYImagePickerAlbumModel> = Array()
    
    /// 当前选择的相册
    public var currentAlbum: MYImagePickerAlbumModel?
    
    /// 当前显示的相册照片列表
    public var currentAssetList:Array<MYImagePickerItemModel> = Array()
    
    /// 控制器
    public weak var viewController: UIViewController? = nil
    
    /// 委托
    open weak var delegate: MYImagePickerViewModelDelegate?
    
    override init() {
        super.init()
        
        //设置图片排序方式
        MYImagePickerManager.share().isSortAscendingByModificationDate = true
    }
    
    /// 加载系统相册
    public func loadAlbumList() -> Void {
        MYImagePickerManager.share().getAlbumListWithCompletion { (albumList) in
            if (albumList.count > 0) {
                self.albumList.removeAll()
                self.albumList.append(contentsOf: albumList)
                self.currentAlbum = albumList.first
                
                if (self.delegate != nil) {
                    self.delegate?.didFinishLoadAlbumList(self, albumList)
                }
            }
        }
    }
    
    /// 加载相册图片资源
    ///
    /// - Parameter album: 相册原始数据源
    public func loadAssetList(album: MYImagePickerAlbumModel) {
        self.currentAlbum = album
        album.getAssetListForAlbum { (list) in
            if (list.count > 0) {
                self.currentAssetList.removeAll()
                self.currentAssetList.append(contentsOf: list)
                
                if (self.delegate != nil) {
                    self.delegate?.didFinishLoadAssetList(self, self.currentAssetList)
                }
            }
        }
    }
    
    /// 选择某个图片
    ///
    /// - Parameter index: 图片索引
    public func onClickToPreviewAssetItem(index: Int) {
        if self.viewController == nil { return }
        
        let vc: MYImagePickerPreviewViewController = MYImagePickerPreviewViewController()
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
