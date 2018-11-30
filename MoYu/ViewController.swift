//
//  ViewController.swift
//  MoYu
//
//  Created by Lawrence on 2018/7/6.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MYImagePickerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var albumList:Array<MYImagePickerAlbumModel> = Array()
        MYImagePickerManager.default.getAlbumListWithCompletion { (albumList:[MYImagePickerAlbumModel]) in
            print(albumList.count)
        }
        
        MYImagePickerManager.default.getCameraRollAlbumListWithCompletion { (list:[MYImagePickerAlbumModel]) in
            
            if list.count == 0 { return }
            print("albumListCount = %d", list.count)
            albumList.append(contentsOf: list)
            print("albumList count\(albumList.count)")
            
            let albumItem: MYImagePickerAlbumModel = list.first!
            albumItem.asyncGetThumbnailImage({ (image) in
                print(image!)
            })
            
            MYImagePickerManager.default.getAssetListForAlbum(album: list.first!, { (assetList:[MYImagePickerItemModel]) in
                print(assetList.count)

                let assetItem: MYImagePickerItemModel = assetList.first!
                let image: UIImage = assetItem.originImage!
                print(image)
            })
        }
        
        MYImagePickerManager.default.saveImage(image: nil) { (isSuccess, eror) in
            print("save image\(String(describing: eror))")
        }
        
        let button: UIButton = UIButton(frame: CGRect(x: self.view.frame.size.width/2, y: 100, width: 50, height: 25))
        button.addTarget(self, action: #selector(onButtonPress), for: UIControl.Event.touchUpInside)
        button.setTitle("相册", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func onButtonPress() {
        let imagePicker: MYImagePicker = MYImagePicker(delegate: self)
        imagePicker.show(self)
    }
    
    func didFinishSelectedImage(imagePicker: MYImagePicker, images: [MYImagePickerItemModel]?) {
        
    }
    
    func cancel(imagePicker: MYImagePicker, isCancel: Bool) {
        
    }
}

