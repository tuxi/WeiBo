//
//  XYConst.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/29.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit

//App Key：2073246685
//App Secret：b95fa57b1197c1ce4c7e67914e10a5ef
//redirect_uri授权回调页：http://www.baidu.com

/** 授权参数 */
let app_key = "2073246685"
let app_secret = "b95fa57b1197c1ce4c7e67914e10a5ef"
let redirect_uri = "http://www.baidu.com"

/** 点击了添加图片按钮的通知 */
let XYClickAddPictureButtonNotification = Notification.Name(rawValue: "XYClickAddPictureButtonNotification")

/** 点击了删除图片按钮的通知 */
let XYClickRemovePictureButtonNotification = Notification.Name(rawValue: "XYClickRemovePictureButtonNotification")

/** 点击了首页微博图片的通知 */
let XYClickStatusPictureNotification = Notification.Name(rawValue: "XYClickStatusPictureNotification")
let statusPicIndexPathKey = "statusPicIndexPathKey"
let statusPicURLsKey = "statusPicURLsKey"
