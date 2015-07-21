//
//  XJRuntime.swift
//  字典转模型
//
//  Created by 若水三千 on 15/7/16.
//  Copyright (c) 2015年 若水三千. All rights reserved.
//
// 首先声明下我工作时间不长但是很热爱这个行业。有不足的地方希望大家指正。我多多请教swift我只研究了10天。专研追求是我的理想哈哈 1156203010 姓名谭向捷这个是我QQ有问题直接反馈18小时在线。多多完善 之前用惯MJExtention的还和他一样的用法。XCode6.4版 2.0我没有试过

import UIKit

let Prefix = "T@"
let Prefix1 = ","
let temp = "."
var CoustomPrefix:String?
var Cla :AnyClass?
let dicCls: AnyClass = NSDictionary.classForCoder()
extension NSObject {
    
    
    /// 通过字典来创建一个模型  @param keyValues 字典 @return 新建的对象如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    class func objectWithKeyValues(Dict:NSDictionary)->Self{
        var objc = self.alloc()
        
        var count:UInt32 = 0
        //        var ivars = class_copyIvarList(self.classForCoder(), &count)
        var properties = class_copyPropertyList(self.classForCoder(),&count)
        
        for var i = 0; i < Int(count); ++i{
            //var ivar :Ivar = ivars[i]
            
            var propert : objc_property_t  = properties[i];
            
            var keys : NSString = NSString(CString: property_getName(propert), encoding: NSUTF8StringEncoding)!
            
            var types : NSString = NSString(CString: property_getAttributes(propert), encoding: NSUTF8StringEncoding)!
            
            var value :AnyObject? = Dict[keys]
            
            CoustomPrefix = (types as NSString).substringFromIndex(Prefix.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            
            if !CoustomPrefix!.hasPrefix(Prefix1){
                var CustomValueName:String? = CoustomPrefix!.componentsSeparatedByString(Prefix1).first!
                
                if  value != nil{
                    //  自定义类型
                    if   value!.isKindOfClass(dicCls) { // Dic
                        
                        // 根据类型字符串创建类
                        Cla = swiftClassFromString(CustomValueName!)
                        
                        if Cla != nil {
                            
                            //  将转换后的类作为Value
                            var CustomValueObject: AnyObject = Cla!.objectWithKeyValues(value as! NSDictionary)
                            objc.setValue(CustomValueObject, forKey: keys as String)
                            
                        }
                        
                    }
                    
                }
                
            }
            if value != nil{
                
                let strCls:AnyClass = NSString.classForCoder()
                let Number:AnyClass = NSNumber.classForCoder()
                let ArrayCls:AnyClass = NSArray.classForCoder()
                
                // swift 类型安全很重要 类型转换
                var valueObj = String(format: "\(value!)")
                
                if value!.isKindOfClass(strCls) {//string
                    
                    objc.setValue(valueObj, forKeyPath:keys as! String)
                    
                }
                
                if  value!.isKindOfClass(Number){ // Number
                    
                    objc.setValue(valueObj, forKeyPath:keys as! String)
                }
                
                if value!.isKindOfClass(NSArray.classForCoder()){ //
                    objc.setValue(valueObj, forKeyPath:keys as! String)
                    
                }
                
                if value!.isKindOfClass(NSURL.classForCoder()){ // url
                    objc.setValue(valueObj, forKeyPath:keys as! String)
                    
                }
                
            }
            
        }
        
        return objc
        
    }
    
    /// 得到自定义类型的类名 如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    private  class func swiftClassFromString(className: String) -> AnyClass! {
        
        if  var appName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
            
            let typeStr = "\""
            if className.hasPrefix(typeStr){
                
                // "\"User1\""
                var rang = (className as NSString).substringFromIndex(typeStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
                // 类型字符串截取
                var length = rang.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
                // User1\""
                rang = (rang as NSString).substringToIndex(length.hashValue-1)
                return NSClassFromString("\(appName).\(rang)")
                
            }
            
        }
        
        return nil;
        
    }
    
    /// 通过字典数组来创建一个模型数组 @param keyValuesArray 字典数组 @return 模型数组 如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    class func objectArrayWithKeyValuesArray(keyValuesArray:[[String:AnyObject]])->NSArray{
        var modelArray = NSMutableArray()
        var array = NSArray()
        for dict in keyValuesArray{
            //   这里的做判断防止出错不会写了
            //            if keyValuesArray.isKindOfClass([[String:AnyObject]]){
            
            var model:AnyObject = objectWithKeyValues(dict)
            modelArray.addObject(model)
            
            //        }else{
            //        打印提示信息可能不是一个字典数组
            //        }
            
            array = modelArray
        }
        return array
    }
}