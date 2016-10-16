//
//  XYHomeViewController.swift
//  XYWeiBo
//
//  Created by mofeini on 16/9/27.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
import FMDB

class XYHomeViewController: XYBaseViewController {
    
    // MARK:- 懒加载属性
    lazy var titleButton : XYTitleButton = XYTitleButton()
    lazy var tipLabel : UILabel = UILabel()
    lazy var popoverAnimation : XYPopoverAnimation = XYPopoverAnimation {[weak self] (isPresented) in
        
        // 设置按钮的选中状态为是否弹出动画
        self?.titleButton.isSelected = isPresented
    }
    lazy var photoBrowerAnimation : XYPhotoBrowerAnimation = XYPhotoBrowerAnimation()
    
    // 存放微博模型的数组
    lazy var statuesViewModels : [XYStatusViewModel] = [XYStatusViewModel]()

    // MARK:- 控制器view的声明周期
    override func viewDidLoad() {
        super.viewDidLoad()

        // 让转盘转起来
        visitorView.rotationAnim()
        
        if !isLogin {
            return
        }
        
        setupNavigationBar()
        
        // 添加下拉刷新和上拉加载更多控件
        setupHeaderView()
        setupFooerView()
        
        // 设置tableView的估算高度
        tableView.estimatedRowHeight = 200
     
        // 添加提示Label
        setupTipLabel()
        
        // 注册通知
        registerNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
}

// MARK:- 设置UI界面
extension XYHomeViewController {
    
    /// 设置导航条
    func setupNavigationBar() {
       
        // 1.左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_friendattention")
        
        // 2.右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_pop")
        
        // 3.设置titleView
        titleButton.setTitle("-狐狸浅的围巾", for: .normal)
        // 给按钮添加点击事件
        titleButton.addTarget(self, action: #selector(titleButtonClick(_:)), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
    
    /// 添加下拉刷新控件
    func setupHeaderView() {
        
        // 1.创建headerView
        let headerView = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(XYHomeViewController.loadNewStatus))
        headerView?.setTitle("下拉可以刷新", for: .idle)
        headerView?.setTitle("松手可以刷新", for: .pulling)
        headerView?.setTitle("正在加载...", for: .refreshing)
        tableView.mj_header = headerView
        headerView?.beginRefreshing()
        
    }
    
    /// 添加上拉加载更多控件
    func setupFooerView() {
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        footer?.setTitle("正在加载", for: .refreshing)
        tableView.mj_footer = footer
    }
    
    /// 添加提示label:当有新的数据更新时，提示用户更新了多少条新微博
    func setupTipLabel() {
        navigationController?.view.insertSubview(tipLabel, at: 1)
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width, height: 32)
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    
    /// 注册通知
    func registerNotification() {
        
        // 注册点击了微博图片的通知
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrower(note:)), name: XYClickStatusPictureNotification, object: nil)
    }

}

// MARK:- 事件的监听
extension XYHomeViewController {

    /// 点击标题按钮
    func titleButtonClick(_ titleBtn: XYTitleButton) {
        
        // 1.弹出控制器
        let popoverVc = XYPopoverViewController()
        
        // 2.设置modal的样式
        popoverVc.modalPresentationStyle = .custom // 为了保证modal出新的控制器后，之前的控制器也不会消失
        
        // 3.设置popoverVc的转场代理为popoverAnimation对象
        popoverVc.transitioningDelegate = popoverAnimation
        // 设置弹出控制器view的frame
        popoverAnimation.presentedViewFrame = CGRect(x: 100, y: 55, width: 180, height: 250)
        
        // 4.弹出控制器
        self.present(popoverVc, animated: true, completion: nil)
        
    }
    
    /// 接收到点击微博图片的通知
    func showPhotoBrower(note: Notification) {
        
        // 1.取出通知的参数
        let picURLs = note.userInfo![statusPicURLsKey] as! [NSURL]
        let indexPath = note.userInfo![statusPicIndexPathKey] as! NSIndexPath
        let object = note.object as! XYPicConllectionView
        
        
        // 2.弹出照片浏览器
        // 创建照片浏览控制器
        let photoBrowerVc = XYPhotoBrowserViewController(indexPath: indexPath, picURLs: picURLs)
        
        // 设置弹出控制器的modal样式为custom，后面的控制器view不会被隐藏
        photoBrowerVc.modalPresentationStyle = .custom
        
        // 设置代理
        photoBrowerVc.transitioningDelegate = photoBrowerAnimation  // 转场代理
        photoBrowerAnimation.presentedDelegate = object             // 照片浏览器弹出动画的代理
        photoBrowerAnimation.dismissDelegate = photoBrowerVc        // 照片浏览器消失动画的代理
        photoBrowerAnimation.indexPath = indexPath
        
        present(photoBrowerVc, animated: true, completion: nil)
    }
}



// MARK:- 请求微博数据
extension XYHomeViewController {
    
    // 请求新数据：下拉刷新
    func loadNewStatus() {
        loadStatuses(isNewData: true)
    }
    
    // 请求更多数据：上拉加载更多
    func loadMoreData() {
        loadStatuses(isNewData: false)
    }
    
    func loadStatuses(isNewData: Bool) {
        
        // 0.获取since_id
        var since_id = 0
        var max_id = 0
        if isNewData { // 下拉刷新数据
            
            since_id = statuesViewModels.first?.statusItem?.id ?? 0
            
        } else {       // 上拉加载更多
            
            max_id = statuesViewModels.last?.statusItem?.id ?? 0
            max_id = max_id == 0 ? 0: (max_id - 1)
            
        }
        
        // 加载微博数据(先查看本地数据库，本地数据没有就从服务器请求数据，请求完成后再缓存到本地)
        XYNetworkTools.shareInstace.loadStatuses(since_id: since_id, max_id: max_id) { (result, error) in
            
            // 1.获取用户ID，如当前无用户ID，则用户未登陆，就不需要加载微博数据
            guard let userID = XYUserAccountViewModel.shareInstance.userAccount?.uid else {
                print("未获取到用户ID，当前用户未登录")
                return
            }
            
            // 2.拼接【SQL查询】语句
            var querySql = "select * from t_status where userID = \(userID)"
            if since_id != 0 {
                querySql += " AND statusID > \(since_id)"
            } else if max_id != 0 {
                let temp = max_id - 1
                querySql += " AND statusID <= \(temp)"
            }
            querySql += " order by statusID desc limit 20" // statusID按照降序，且每页返回20条微博
            print(querySql)
            
            // 3.0执行SQL语句
            // 定义一个微博视图模型数组，用于将本地数据库查询到的数据添加到里面的
            var viewModels : [XYStatusViewModel] = [XYStatusViewModel]()
            SQLiteManager.sharedInstance.dbQueue?.inDatabase({ (db: FMDatabase?) in
                // 3.1 获取到查询的结果
                guard let resultSet = db?.executeQuery(querySql, withArgumentsIn: nil) else {
                    print("没有查询到结果")
                    return
                }
                // 3.2 遍历查询的结果
                while resultSet.next() {
                    //3.3获取微博数据字符串
                    guard let statusText = resultSet.string(forColumn: "statusText") else {
                        print("未获取到微博数据字符串")
                        continue
                    }
                    // 3.4将微博数据字符串转换为字典
                    guard let statusData = statusText.data(using: String.Encoding.utf8) else {
                        print("微博字符串转换为二进制数据失败")
                        continue
                    }
                    guard let statusDict = try? JSONSerialization.jsonObject(with: statusData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any] else {
                        print("微博二进制数据转换字典类型失败")
                        continue
                    }
                    // 3.5将 微博字典 转换为 微博模型 拼接到 微博视图模型数组 中
                    viewModels.append(XYStatusViewModel.init(statusItem: XYStatusItem(dict: statusDict)))
                }
                
                // 3.6判断存储本地数据库的 微博视图模型数组 中是否有值， 如果有则将其添加到大数组中并显示出，没有就去服务器请求
                if viewModels.count != 0 {
                    print("从本地数据库加载数据")
                    
                    if isNewData {
                        
                        self.statuesViewModels = viewModels + self.statuesViewModels
                    } else {
                        self.statuesViewModels += viewModels
                    }
                    
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                }
                
            })
            
            if viewModels.count == 0 {
                // 本地数据库没有，就去服务器请求数据
                self.loadStatusFromNetworking(isNewData: isNewData, since_id: since_id, max_id: max_id, result: result, error: error)
            }
        }
    }
    
    /// 从服务器请求数据(请求完成后缓存到本地)
    private func loadStatusFromNetworking(isNewData: Bool, since_id: Int, max_id: Int, result: [[String: Any]]?, error: Error?) {
    
        print("服务器请求数据")
        // 1.容错处理
        if error != nil {
            print(error)
            return
        }
        
        // 2.获得可选类型result中的数据
        guard let resultArray = result else {
            return
        }
        
        // 3.定义一个新数据临时数组数组，专门讲请求的新数据全部装在这里面
        var tempViewModels = [XYStatusViewModel]()
        // 3.遍历微博对应字典
        for statusDict in resultArray {
            // 将每一个模型转换为字典
            let status = XYStatusItem(dict: statusDict)           // 创建字典模型
            let viewModel = XYStatusViewModel(statusItem: status) // 创建视图模型
            tempViewModels.append(viewModel)                   // 将视图模型添加到新数据的临时数组数组中
        }
        
        if isNewData {
            
            // 下拉加载新数据时，将新数据的临时数组拼接到大数组的前面
            self.statuesViewModels = tempViewModels + self.statuesViewModels
        } else {
            // 上拉加载更多数据时，将临时数组拼接到大数组的后面
            self.statuesViewModels += tempViewModels
            
        }
        
        // 4.缓存新的配图图片tempViewModels，不要全部缓存
        self.cachePicture(viewModels: tempViewModels, isNewData: isNewData)
        
        // 5.缓存微博数据到本地数据库
        self.cacheStatus(statusArray: resultArray)
    }
    
    /// 缓存图片
    private func cachePicture(viewModels: [XYStatusViewModel] , isNewData: Bool) {
        
        // 创建组
        let group = DispatchGroup()
        
        // 取出viewModels中所有的viewModel
        for viewModel in viewModels {
            
            for picUrl in viewModel.picURLs {
                // 开始下载图片
                // 将任务添加到group中
                group.enter()
                SDWebImageManager.shared().downloadImage(with: picUrl, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    //print("下载图片")
                    // 任务完成后离开组
                    group.leave()
                })
            }
        }
        
        // 当group中的任务执行完毕后在主线程中刷新表格
        group.notify(queue: .main) {
        
            self.tableView.reloadData()
            
            // 结束下拉刷新
            self.tableView.mj_header.endRefreshing()
            // 接收上拉加载更多
            self.tableView.mj_footer.endRefreshing()
            
            if isNewData { // 如果是新数据才需要提示用户，上拉加载更多时不需要提示
            
            // 显示tipLabel，并执行动画效果
            self.showTipLabel(count: viewModels.count)
            }
        }
    }
    
    /// 缓存微博数据
    private func cacheStatus(statusArray: [[String: Any]]) {
        
        // 1.取出用户id
        guard let userID = XYUserAccountViewModel.shareInstance.userAccount?.uid else {
            print("没有用户ID")
            return
        }
        
        // 2.遍历从服务器请求的字典数组,拿到每一条微博数据
        for statusDict in statusArray {
            // 2.1获取每条微博的ID 
            guard let statusID = statusDict["idstr"] else {
                print("没有获取到微博ID")
                continue
            }
            
            // 2.2将微博数据字典类型转换为字符串类型
            guard let statusData = try? JSONSerialization.data(withJSONObject: statusDict, options: JSONSerialization.WritingOptions.prettyPrinted) else {
                print("微博字典转二进制数据失败")
                continue
            }
            guard let statusText = String(data: statusData, encoding: String.Encoding.utf8) else {
                print("微博二进制数据转换字符串数据类型失败")
                continue
            }
            
            // 3.拼接sql插入语句
            let insertSql = "insert into t_status(statusID, statusText, userID) values (?, ?, ?)"
            
            // 4.执行sql语句
            SQLiteManager.sharedInstance.dbQueue?.inDatabase({ (db: FMDatabase?) in
                db?.executeUpdate(insertSql, withArgumentsIn: [statusID, statusText, userID])
            })
            
        }
    }
    
    func showTipLabel(count: Int) {
        
        self.tipLabel.isHidden = false
        UIView .animate(withDuration: 1.0, animations: {
            
            self.tipLabel.frame.origin.y = 64
            self.tipLabel.text = count == 0 ? "没有新数据" : "\(count)  条新微博"
            }) { (_) in
                
                UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: { 
                    
                    self.tipLabel.frame.origin.y = 32
                    }, completion: { (_) in
                        
                        self.tipLabel.isHidden = true
                })
        
        }
    }


}


// MARK:- tableView的数据源和代理方法
extension XYHomeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.statuesViewModels.count
        
        tableView.mj_footer.isHidden = count == 0
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let HomeCellID = "HomeCellID"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellID) as! XYHomeViewCell
        
        
        cell.viewModel = self.statuesViewModels[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let viewModel = self.statuesViewModels[indexPath.row]
        
        return viewModel.cellHeight
    }
}



