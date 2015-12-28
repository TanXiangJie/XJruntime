//
//  ViewController.swift
//  字典转模型
//
//  Created by 若水三千 on 15/7/21.
//  Copyright (c) 2015年 若水三千. All rights reserved.
//
// 目前功能不完善之处大家多多包含 毕竟我工作时间不长。swift也是花了10天学习的。多多包涵
import UIKit

class ViewController: UITableViewController {
   var array = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.view.backgroundColor = UIColor.whiteColor()
        
//  通过plist 文件创建模型数组
       array = StatusResult.objectArrayWithFilename("status.plist")!

        self.tableView.reloadData()
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return array.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        var row=indexPath.row as Int
        var u:StatusResult = array[row] as! StatusResult
        
        cell.textLabel?.text = u.user.name
        cell.detailTextLabel?.text = u.user.profile_image_url
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        
        return cell
    }
    

    //  cellHeight
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
}
