//
//  MYImagePickerNavigationController.swift
//  MoYu
//  导航栏基类
//  Created by zengqingsong on 2018/11/30.
//  Copyright © 2018 Lawrence. All rights reserved.
//

import UIKit

class MYImagePickerNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}
