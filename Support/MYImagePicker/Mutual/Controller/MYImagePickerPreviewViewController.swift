//
//  MYImagePickerPreviewViewController.swift
//  MoYu
//  相册图片预览页面
//  Created by Lawrence on 2018/7/27.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerPreviewViewController: UIViewController {
    
    /// 相册数据
    public var images:[MYImagePickerItemModel]? = nil
    
    //MARK: - 初始化
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 设置UI
    private func setupUI() {
        self.view.addSubview(self.imageBrowserView)
        self.view.backgroundColor = UIColor.black
    }
    
    private lazy var imageBrowserView: MYImagePickerBrowserView = {
        () -> MYImagePickerBrowserView in
        let aView = MYImagePickerBrowserView(frame: self.view.frame)
        aView.images = self.images
        
        return aView
    }()
}
