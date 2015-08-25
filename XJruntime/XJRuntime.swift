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

            if !CoustomPrefix!.hasPrefix(","){
                var CustomValueName:String? = CoustomPrefix!.componentsSeparatedByString(",").first!
              
             //  自定义类型
              if value != nil && value!.isKindOfClass(NSDictionary.classForCoder()) { // Dic
                        
                        // 根据类型字符串创建类
                
                        if swiftClassFromString(CustomValueName!) != nil {
                          // 递归
                            var CustomValueObject: AnyObject =
                            swiftClassFromString(CustomValueName!).objectWithKeyValues(value as! NSDictionary)
                            
                            objc.setValue(CustomValueObject, forKey: keys as String)
                            
                        }
                        
                    }

               }
            
            if value != nil{
                // swift 类型安全很重要 类型转换
                if value!.isKindOfClass(NSString.classForCoder()) {//string

                    objc.setValue("\(value!)", forKeyPath:keys as! String)
                    
                }
                
                if  value!.isKindOfClass(NSNumber.classForCoder()){ // Number

                    objc.setValue("\(value!)", forKeyPath:keys as! String)
                }
                
                if value!.isKindOfClass(NSArray.classForCoder()){ //

                    objc.setValue(value!.allObjects, forKeyPath:keys as! String)
                    
                }
                
                if value!.isKindOfClass(NSURL.classForCoder()){ // url

                    objc.setValue("\(value!)", forKeyPath:keys as! String)
                    
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
                
                // "\"User\""
                var rang = (className as NSString).substringFromIndex(typeStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
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
    
    class func objectArrayWithKeyValuesArray(keyValuesArray:[[String:AnyObject]])->NSArray{
        var modelArray = NSMutableArray()
        
        var array = NSArray()
        
        for dict in keyValuesArray{
            
            modelArray.addObject(objectWithKeyValues(dict))
            
            array = modelArray
        }
        return array
    }
    
    /// 通过plist来创建一个模型数组 @param file 文件全路径 @return 新建的对象 如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    class func objectArrayWithFilename(filename:String!)->NSArray?{
        
        let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: nil)
        
        if filePath != nil {
            
            var dict = NSDictionary(contentsOfFile: filePath!)
            var  value: AnyObject? = dict!.objectForKey(dict!.allKeys.first!)
         
            if value == nil  {return nil}
            var arrayObj = NSArray()
            if value!.isKindOfClass(NSArray.classForCoder()){
                
               arrayObj = objectArrayWithKeyValuesArray(value as!
                        [[String : AnyObject]])
                
            }else{
                
            println("Value 不是一个字典数组 请使用其他方法")
                
            }
            return arrayObj
            
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
            
            if value != nil && value!.isKindOfClass(NSDictionary.classForCoder()){
                
                objc = objectWithKeyValues(value! as! NSDictionary)
                
            }else{
                
                println("value 不是一个字典")
  
                }
           
           
            return objc
        }
}