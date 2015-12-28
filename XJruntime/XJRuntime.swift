//
//  XJRuntime.swift
//  字典转模型
//
//  Created by 若水三千 on 15/7/16.
//  Copyright (c) 2015年 若水三千. All rights reserved.
//
//
import Foundation
extension NSObject {
    
    /// 通过字典来创建一个模型  @param keyValues 字典
    class func objectWithKeyValues(dict:[String: AnyObject])->Self{
        let objc = self.init(initialize())
        
        var count:UInt32 = 0
        
        let ivars = class_copyIvarList(self.classForCoder(), &count)
        
        let properties = class_copyPropertyList(self.classForCoder(), &count)
        
        for var i = 0; i < Int(count); ++i{
            
            let ivar :Ivar = ivars[i]
            
            let property : objc_property_t  = properties[i];
            
            let keys = ivar_getName(ivar)
            //      ivar_getTypeEncoding 主要是这个不会拿到任何东西 只能用了 objc_property_t
            if let varName = String.fromCString(keys) {
                let types : NSString = NSString(CString: property_getAttributes(property), encoding: NSUTF8StringEncoding)!
                let CoustomPrefix:String  = types.substringFromIndex("T@".lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
                let CustomValueName:String = CoustomPrefix.componentsSeparatedByString(",").first!
                
                let Attributes=(CustomValueName as NSString).substringWithRange(NSMakeRange(1,CustomValueName.characters.count-2))
                print(Attributes);
                let value = dict[varName]
                
                if Attributes.hasPrefix("_TtC9"){ // 自定义类
                    if value is [String:AnyObject]{
                        
                        let  tempDic:AnyObject  = NSClassFromString(Attributes)!.objectWithKeyValues(value as! [String:AnyObject])
                        objc.setValue(tempDic, forKeyPath:varName as String)
                        
                    }
                    if(value is [String]){
                        
                        let tempArray =   NSClassFromString(Attributes)!.objectArrayWithKeyValuesArray(value as! [String])
                        objc.setValue(tempArray, forKeyPath:varName as String)
                        
                    }
                    
                }else{ // 其他
                    
                    if value is NSNumber {
                        
                        objc.setValue("\(value)", forKeyPath:varName as String)
                        
                    }else {
                        objc.setValue( value, forKeyPath:varName as String)
                        
                    }
                    
                }
                
            }
            
        }
        
        free(ivars) // 释放内存
        free(properties)
        return objc
    }
    
    /// 通过字典数组来创建一个模型数组 @param keyValuesArray 字典数组 @return 模型数组
    
    class func objectArrayWithKeyValuesArray(keyValuesArray:[AnyObject])->[AnyObject]?{
        var modelArray = [AnyObject]()
        for dict in keyValuesArray{
            let model:AnyObject = objectWithKeyValues(dict as! [String:AnyObject])
            
            modelArray.append(model)
        }
        
        return modelArray
    }
    /// 通过plist来创建一个模型数组 @param file 文件全路径 @return 新建的对象
    class func objectArrayWithFilename(filename:String)->[AnyObject]?{
        
        let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: nil)
        
        if filePath != nil {
            
            let dict = NSDictionary(contentsOfFile: filePath!)
            let  value: AnyObject? = dict!.objectForKey(dict!.allKeys.first!)
            
            if value == nil  {return nil}
            
            if value! is [AnyObject] {
                
                return  objectArrayWithKeyValuesArray(value as! [AnyObject])
                
            }else{
                
                print("Value 不是一个字典数组 请使用其他方法")
                
            }
            
        }
        
        print("文件路径不对，可能文件名有误请查证")
        
        return nil
        
    }
    
    ///  通过plist来创建一个模型 @param filename 文件名(仅限于mainBundle中的文件)  @return 模型数组
    
    class func objectWithFileName(filename:String)->Self{
        
        let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: nil)
        
        let dict = NSDictionary(contentsOfFile: filePath!)
        let  value: AnyObject? = dict!.objectForKey(dict!.allKeys.first!)
        
        var objc = self.init()
        
        if value != nil && value! is [String:AnyObject]{
            
            objc = objectWithKeyValues(value! as! [String:AnyObject])
            
        }else{
            
            print("value 不是一个字典")
            
        }
        return objc
    }
}