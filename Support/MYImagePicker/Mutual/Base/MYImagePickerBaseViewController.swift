//
//  MYImagePickerBaseViewController.swift
//  MoYu
//
//  Created by zengqingsong on 2018/11/30.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerBaseViewController: UIViewController {
    
    public var tintColor: UIColor? = UIColor.black
    public var barTintColor: UIColor? = UIColor.white

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置背景颜色
        self.view.backgroundColor = UIColor.white
        
        //导航栏样式设置
        self.navigationController?.navigationBar.barTintColor = self.barTintColor
        self.navigationController?.navigationBar.tintColor = self.tintColor
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
