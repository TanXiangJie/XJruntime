//
//  User.swift
//  字典转模型
//
//  Created by 若水三千 on 15/7/21.
//  Copyright (c) 2015年 若水三千. All rights reserved.
//

import Foundation

class User: NSObject {
    
    //            返回值字段	字段类型	字段说明
    //            id	int64	用户UID
    //
    //            idstr	string	字符串型的用户UID
    //            screen_name	string	用户昵称
    //            name	string	友好显示名称
    //            province	int	用户所在省级ID
    //            city	int	用户所在城市ID
    //            location	string	用户所在地
    //            description	string	用户个人描述
    //            url	string	用户博客地址
    //            profile_image_url	string	用户头像地址（中图），50×50像素
    //            profile_url	string	用户的微博统一URL地址
    //            domain	string	用户的个性化域名
    //            weihao	string	用户的微号
    //            gender	string	性别，m：男、f：女、n：未知
    //            followers_count	int	粉丝数
    //            friends_count	int	关注数
    var id  : String?
    var screen_name : String?
    var name  : String?
    var province  : String?
    var city  : String?
    var location  : String?
    
    var url  : String?
    var profile_image_url :String?
    
    var profile_url  : String?
    var domain  : String?
    var weihao  : String?
    var gender  : String?
    var followers_count  : String?
    var friends_count  : String?
    var statuses_count  : String?
    var favourites_count  : String?
    var avatar_hd  : String?
    var follow_me  : String?
    var online_status  : String?
    var bi_followers_count  : String?
    var remark  : String?
    var status  : String?
    var allow_all_comment  : String?
    var allow_all_act_msg  : String?
    
    
    //            statuses_count	int	微博数
    //            favourites_count	int	收藏数
    //            created_at	string	用户创建（注册）时间
    //            allow_all_act_msg	boolean	是否允许所有人给我发私信，true：是，false：否
    //            geo_enabled	boolean	是否允许标识用户的地理位置，true：是，false：否
    //            verified	boolean	是否是微博认证用户，即加V用户，true：是，false：否
    //            remark	string	用户备注信息，只有在查询用户关系时才返回此字段
    //            status	object	用户的最近一条微博信息字段 详细
    //            allow_all_comment	boolean	是否允许所有人对我的微博进行评论，true：是，false：否
    //            avatar_large	string	用户头像地址（大图），180×180像素
    //            avatar_hd	string	用户头像地址（高清），高清头像原图
    //            follow_me	boolean	该用户是否关注当前登录用户，true：是，false：否
    //            online_status	int	用户的在线状态，0：不在线、1：在线
    //            bi_followers_count	int	用户的互粉数
    
    
}
