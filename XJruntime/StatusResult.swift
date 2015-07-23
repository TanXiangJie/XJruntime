//
//  StatusResult.swift
//  swift新浪演练
//
//  Created by 若水三千 on 15/7/16.
//  Copyright (c) 2015年 若水三千. All rights reserved.
//

import UIKit

 class StatusResult: NSObject {

    //    created_at	string	微博创建时间
    var created_at = String()
    
    //    id	int64	微博ID
    var id = String()
//    
//    //    idstr	string	字符串型的微博ID
    var idstr = String()
//    
//    //    text	string	微博信息内容
    var text = String()
//    
    //    source	string	微博来源
    var source = String()
//    
//    //    thumbnail_pic	string	缩略图片地址，没有时不返回此字段
    var thumbnail_pic = String()
//    
//    //    bmiddle_pic	string	中等尺寸图片地址，没有时不返回此字段
    var bmiddle_pic = String()
//    
//    //    original_pic	string	原始图片地址，没有时不返回此字段
    var original_pic = String()
//    
//    //    user	object	微博作者的用户信息字段 详细
//    var user = NSDictionary()
//    //    retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细
    var retweeted_status : StatusResult?
//
//    //    reposts_count	int	转发数
    var reposts_count = String()
//    
//    //    comments_count	int	评论数
    var comments_count = String()
//    
//    //    attitudes_count	int	表态数
    var attitudes_count = String()
//    
//    //    pic_ids	object	微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
    var pic_urls = NSArray()
    
    func objceClassInArray()->[String:AnyObject]{
        
        return ["pic_urls":photos.classForCoder()];
        
    }
    var user = User()
    
//    func objceClassInArray()-> NSDictionary {
//        
//        return ["pic_urls":photos.classForCoder()];
//        
//    }
    
}
