//
//  MYImagePickerBaseViewController.swift
//  MoYu
//  控制器基类
//  Created by zengqingsong on 2018/11/30.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置背景颜色
        self.view.backgroundColor = UIColor.white
        
        //导航栏样式设置
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
}
