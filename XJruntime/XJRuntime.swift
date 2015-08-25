//
//  XJRuntime.swift
//  字典转模型
//
//  Created by 若水三千 on 15/7/16.
//  Copyright (c) 2015年 若水三千. All rights reserved.
//
//
import UIKit
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
            var CoustomPrefix:String?
            = types.substringFromIndex("T@".lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            var CustomValueName:String?
            if !CoustomPrefix!.hasPrefix(","){
                CustomValueName = CoustomPrefix!.componentsSeparatedByString(",").first!
            }
            //  自定义类型
            if value != nil{
                if  value! is [String:AnyObject] {
                    // 根据类型字符串创建类
                    
                    if swiftClassFromString(CustomValueName!) != nil {
                        // 递归
                        var CustomValueObject: AnyObject =
                        swiftClassFromString(CustomValueName!).objectWithKeyValues(value as! [String:AnyObject])
                        
                        objc.setValue(CustomValueObject, forKey: keys as String)
                    }
                    
                }else{
                    
                    if value! is NSNumber {
                        
                        objc.setValue("\(value!)", forKeyPath:keys as! String)
                        
                    }else{
                        objc.setValue(value!, forKeyPath:keys as! String)
                        
                    }
                    
                }
            }
            
        }
        
        return objc
        
    }
    
    /// 得到自定义类型的类名 如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    private  class func swiftClassFromString(className: String) -> AnyClass! {
        
        if  var appName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
            
            if className.hasPrefix("\""){
                
                // "\"User\""
                var rang = (className as NSString).substringFromIndex("\"".lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
                // 类型字符串截取
                var length = rang.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
                // User\""
                rang = (rang as NSString).substringToIndex(length.hashValue-1)
                return NSClassFromString("\(appName).\(rang)")
                
            }
            
        }
        
        return nil;
        
    }
    
    /// 通过字典数组来创建一个模型数组 @param keyValuesArray 字典数组 @return 模型数组 如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    class func objectArrayWithKeyValuesArray(keyValuesArray:[AnyObject])->[AnyObject]{
        var modelArray = [AnyObject]()
        for dict in keyValuesArray{
            
            var model:AnyObject = objectWithKeyValues(dict as! [String:AnyObject])
            modelArray.append(model)
        }
        return modelArray
    }
    /// 通过plist来创建一个模型数组 @param file 文件全路径 @return 新建的对象 如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    class func objectArrayWithFilename(filename:String!)->NSArray?{
        
        let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: nil)
        
        if filePath != nil {
            
            var dict = NSDictionary(contentsOfFile: filePath!)
            var  value: AnyObject? = dict!.objectForKey(dict!.allKeys.first!)
            
            if value == nil  {return nil}
            
            if value! is [AnyObject] {
                
                return  objectArrayWithKeyValuesArray(value as! [AnyObject])
                
            }else{
                
                println("Value 不是一个字典数组 请使用其他方法")
                
            }
            
        }
        
        println("文件路径不对，可能文件名有误请查证")
        
        return nil
        
    }
    
    ///  通过plist来创建一个模型 @param filename 文件名(仅限于mainBundle中的文件)  @return 模型数组 如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    class func objectWithFileName(filename:String!)->Self{
        
        let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: nil)
        
        var dict = NSDictionary(contentsOfFile: filePath!)
        var  value: AnyObject? = dict!.objectForKey(dict!.allKeys.first!)
        
        var objc = self.alloc()
        
        if value != nil && value! is [String:AnyObject]{
            
            objc = objectWithKeyValues(value! as! [String:AnyObject])
            
        }else{
            
            println("value 不是一个字典")
            
        }
        return objc
    }
}