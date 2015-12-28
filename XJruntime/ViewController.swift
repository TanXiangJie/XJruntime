//
//  ViewController.swift
//  字典转模型
//
//  Created by 若水三千 on 15/7/21.
//  Copyright (c) 2015年 若水三千. All rights reserved.
//
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
        let identify:String = "SwiftCell"
        
        //        var cell = tableView.dequeueReusableCellWithIdentifier(identify)! as! UITableViewCell
        let row=indexPath.row as Int
        let u:StatusResult = array[row] as! StatusResult
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:identify)
        
        cell.textLabel?.text = u.user.name
        cell.detailTextLabel?.text = u.user.profile_image_url
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        let url: NSURL = NSURL(string: u.user.profile_image_url!)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response, data, error) -> Void in
            
            if ((error) != nil) {
                //Handle Error here
            }else{
                cell.imageView?.image = UIImage(data: data!)
            }
            
        })
        return cell
    }
    //  cellHeight
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
}
