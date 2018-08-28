//
//  MYImagePickerPreviewViewController.swift
//  MoYu
//  相册图片预览页面
//  Created by Lawrence on 2018/7/27.
//  Copyright © 2018年 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerPreviewViewController: UIViewController {
    
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
    
    // MARK: - private func
    
    /// 设置UI
    private func setupUI() {
        
        //设置背景颜色
        self.view.backgroundColor = UIColor.white
    }
}
