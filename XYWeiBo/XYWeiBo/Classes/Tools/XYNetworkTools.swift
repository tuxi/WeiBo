//
//  XYNetworkingTools.swift
//  AFNetworking封装工具类
//
//  Created by mofeini on 16/9/29.
//  Copyright © 2016年 sey. All rights reserved.
//

import AFNetworking

// MARK:- 定义枚举
enum XYRequestType : String {
    
    case GET  =  "GET"
    case POST =  "POST"
}

class XYNetworkTools: AFHTTPSessionManager {
    
    // MARK:- 单例
    // 使用闭包的方式初始化单例(方便初始化的时候给单例对象赋值)
    static let shareInstace : XYNetworkTools = {
        
        let tool = XYNetworkTools()
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tool
    }()

    
}

// MARK:- 封装网络请求方法
extension XYNetworkTools {
    
    /// 发送GET和POST请求
    func request(requestType: XYRequestType, urlSring: String, parameters: [String: Any], finishedCallBack:@escaping (_ result: Any?, _ error: Error?) -> ()) {
        
        // 1.定义成功回调的闭包
        let successCallBack = { (task: URLSessionDataTask, result: Any?) in
            
            finishedCallBack(result, nil)
            
        }
        
        // 2.定义失败回调的闭包
        let failureCallBack = { (task: URLSessionDataTask?, error: Error) in
            finishedCallBack(nil, error)
        }
        
        
        // 3.发布网络请求
        if requestType == .GET { // GET请求
            get(urlSring, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            
        } else if requestType == .POST { // POST请求
            post(urlSring, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
    
}

// MARK:- 获取AccessToken
extension XYNetworkTools {
    
    // 获取AccessToken
    func loadAccessToken(code: (String), finisedCallBack: @escaping (_ result: [String: Any]?, _ error : Error?) -> ()) {
        
        // 1. 获取请求路径
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 2.拼接参数
        let parameters = ["client_id": app_key, "client_secret": app_secret, "grant_type": "authorization_code", "code": code, "redirect_uri": redirect_uri]
        
        // 3.发送POST请求
        request(requestType: .POST, urlSring: urlString, parameters: parameters) { (result, error) in
            
            // 请求完成后将服务器返回的结果回调给闭
            finisedCallBack(result as? [String: Any], error)
        }
        
    }
}

// MARK:- 获取用户的信息
extension XYNetworkTools {

    func loadUserInfo(access_token : String, uid : String, finisedCallBack: @escaping (_ result: [String: Any]?, _ error: Error?) -> ()) {
        
        // 1.获取请求路径
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        // 2.拼接参数
        let parameters = ["access_token": access_token, "uid": uid]
        
        // 3.发送GET请求
        request(requestType: .GET, urlSring: urlString, parameters: parameters) { (result, error) in
            
            // 请求完成后回调闭包
            finisedCallBack(result as? [String : Any], error)
        }
    }
}

// MARK:- 请求微博数据:获取当前登录用户及其所关注（授权）用户的最新微博 接口statuses/home_timeline
extension XYNetworkTools {

    func loadStatuses(since_id: Int, max_id: Int, finisedCallBack: @escaping (_ result : [[String : Any]]?, _ error : Error?) -> ()) {
        // 1.获取请求路径
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // 2.拼接请求参数
        let parameters = ["access_token": (XYUserAccountViewModel.shareInstance.userAccount?.access_token)!, "since_id": "\(since_id)", "max_id": "\(max_id)"]
        
        // 3.发送GET请求
        request(requestType: .GET, urlSring: urlString, parameters: parameters) { (result, error) in
            
            // 服务器返回的json数据，本身是一个字典，我们需要字典中的statuses这个数组(里面都是微博)
            guard let resultDict = result as? [String : Any] else {
                print(error)
                finisedCallBack(nil, error)
                return
            }
            
            let statusesArray = resultDict["statuses"] as? [[String: Any]]
            
            // 将数组数据回调
            finisedCallBack(statusesArray , error)
            
        }
        
    }
    
}

// MARK:- 发布一条文字微博，接口statuses/update
extension XYNetworkTools {
    
    func senderStatus(statusText: String, isSuccesCallBck: @escaping (_ isSucces: Bool) -> ()) {
        
        // 1.获取请求路径
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        let access_token = XYUserAccountViewModel.shareInstance.userAccount?.access_token
        // 2.拼接POST参数
        let parameters = ["access_token": access_token!, "status": statusText]
        
        // 3.发送POST请求
        request(requestType: .POST, urlSring: urlString, parameters: parameters) { (result, error) in
            
            if result != nil { // 发布成功
                isSuccesCallBck(true)
            } else {
                print(error)
                isSuccesCallBck(false)
            }
            
        }
        
        
    }
}

// MARK:- 上传图片并发布一条微博
extension XYNetworkTools {
    
    func senderStatus(statusText: String, image: UIImage, isSuccesCallBack: @escaping (_ isSucces: Bool) -> ()) {
        
        // 1.获取请求路径
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        
        // 2.拼接POST参数
        let access_token = XYUserAccountViewModel.shareInstance.userAccount?.access_token
        let parameters = ["access_token": access_token!, "status": statusText]
        
        // 3.发送POST请求
        post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            
            // 上传图片的参数：pic	必须要有	（要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M）
            // 3.1将图片转换为二进制数据
            if let imageData = UIImageJPEGRepresentation(image, 1.0) { // 可选对象校验
                // 3.2将图片的二进制数据拼接到闭包参数中进行回调
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "sey.png", mimeType: "image/png")
            }
            
            }, progress: nil, success: { (_, _) in // 请求成功
                
                isSuccesCallBack(true
                )
            }) { (_, error) in                     // 请求失败
                
              isSuccesCallBack(false)
        }
    }

}
