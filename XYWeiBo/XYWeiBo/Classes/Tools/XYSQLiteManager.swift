//
//  SQLiteManager.swift
//  FMDB
//
//  Created by mofeini on 16/10/15.
//  Copyright © 2016年 sey. All rights reserved.
//

import UIKit
import FMDB

class SQLiteManager: NSObject {

    // 单例对象
    static let sharedInstance: SQLiteManager = SQLiteManager()
    
    var dbQueue : FMDatabaseQueue?
    
    
    // 打开数据库
    func openDB(dbName: String) -> () {
        
        // 1.获取文件存储的路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fullPath = path! + "/" + dbName
        print(fullPath)
        // 2.创建数据库
        dbQueue = FMDatabaseQueue(path: fullPath)
        
        // 3.创建表
        createTable()
    }
    
    /// 创建表
    private func createTable() {
    
        // 1.拼接创建表的sql语句
        let createTableSql = "create table if not exists t_status(statusID integer primary key not null, statusText text not null, userID text not null, createTime text not null default(datetime('now', 'localtime')))"
        
        // 2.执行sql语句
        dbQueue?.inDatabase({ (db: FMDatabase?) in
            if db!.executeUpdate(createTableSql, withArgumentsIn: nil) {
                print("创建表成功")
            } else {
                print("创建表失败")
            }
        })
        
    }
    
    /// 清除本地数据库中微博缓存的数据
    func clearStatusData(howMuchDaysAgo: Double) ->() {
        /***********给一个天数，将其转换为这天之前的时间*************/
        // 1.获取传进来那天前的时间(秒)
        let daysAgoTime = Date(timeIntervalSinceNow: -howMuchDaysAgo * 24 * 60 * 60)
        
        // 2.将传进来那天前时间的秒转换为日期字符串
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: daysAgoTime)
        
        // 3.拼接删除微博的sql语句
        let deleteSql = "DELETE FROM t_status WHERE createTime < '\(dateString)'"
        
        // 4.执行sql语句
        dbQueue?.inDatabase({ (db: FMDatabase?) in
            db?.executeUpdate(deleteSql, withArgumentsIn: nil)
        })
        
        
    }

    
}
