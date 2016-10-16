//
//  XYNavigationController.swift
//  XYWeiBo
//
//  Created by mofeini on 16/10/17.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

class XYNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }


}
