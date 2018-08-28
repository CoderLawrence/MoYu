//
//  ViewController.swift
//  MoYu
//
//  Created by Lawrence on 2018/7/6.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var albumList:Array<MYImagePickerAlbumModel> = Array()
        MYImagePickerManager.share().getAlbumListWithCompletion { (albumList:Array<MYImagePickerAlbumModel>) in
            print(albumList.count)
        }
        
        MYImagePickerManager.share().getCameraRollAlbumListWithCompletion { (list:Array<MYImagePickerAlbumModel>) in
            
            if list.count == 0 { return }
            print("albumListCount = %d", list.count)
            albumList.append(contentsOf: list)
            print("albumList count\(albumList.count)")
            
            let albumItem: MYImagePickerAlbumModel = list.first!
            albumItem.asyncGetThumbnailImage({ (image) in
                print(image!)
            })
            
            MYImagePickerManager.share().getAssetListForAlbum(album: list.first!, { (assetList:Array<MYImagePickerItemModel>) in
                print(assetList.count)

                let assetItem: MYImagePickerItemModel = assetList.first!
                let image: UIImage = assetItem.originImage!
                print(image)
            })
        }
        
        MYImagePickerManager.share().saveImage(image: nil) { (isSuccess, eror) in
            print("save image\(String(describing: eror))")
        }
        
        let button: UIButton = UIButton(frame: CGRect(x: self.view.frame.size.width/2, y: 100, width: 50, height: 25))
        button.addTarget(self, action: #selector(onButtonPress), for: UIControlEvents.touchUpInside)
        button.setTitle("相册", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func onButtonPress() {
        MYImagePickerViewController.show(in: self, delegate: nil)
    }
}

