//
//  MYImagePickerBrowserViewController.swift
//  MoYu
//  相册图片预览页面
//  Created by Lawrence on 2018/7/27.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerBrowserViewController: MYImagePickerBaseViewController {
    
    /// 相册数据
    public var images: [MYImagePickerItemModel]?
    
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
        self.addSingleTapCallBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
        let frame = CGRect.init(x: -kMYBrowserPhotoMarginX, y: 0, width: self.view.width + kMYBrowserPhotoMarginX * 2, height: self.view.height)
        let aView = MYImagePickerBrowserView(frame: frame)
        aView.images = self.images
        
        return aView
    }()
    
    //MARK: - 监听
    private func addSingleTapCallBack() {
        self.imageBrowserView.singleTapCallBack = {[weak self] in
            guard let `self` = self else { return }
//            let isHidden = self.navigationController?.isNavigationBarHidden ?? false
//            self.navigationController?.setNavigationBarHidden(!isHidden, animated: true)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
