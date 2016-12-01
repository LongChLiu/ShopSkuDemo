//
//  StandardModel.swift
//  ShopSkuDemo
//
//  Created by zzzsw on 2016/12/1.
//  Copyright © 2016年 sunbohong. All rights reserved.
//

import Foundation


class standardClassInfo: NSObject {

    //规格分类名称
    var standardClassName : String! = nil
    //规格分类id
    var standardClassId : NSString! = nil
    //两个初始化方法
    class func standardClassInfo(classId:String,standClassName:String)->standardClassInfo{
        return standardClassInfo(classId:classId,standClassName:standClassName)
    }

    convenience init(classId:String,standClassName:String){
        self.init()
        self.standardClassId = classId as NSString!
        self.standardClassName = standClassName
    }

}



class StandardModel: NSObject {


    var standardName : String! = nil
    var standardClassInfoArr : [standardClassInfo]! = nil

    class func standardModel(classInfo:[standardClassInfo],standName:String)->StandardModel{
        return StandardModel(classInfo:classInfo,standName:standName)
    }


    convenience init(classInfo:[standardClassInfo],standName:String){
        self.init()
        self.standardClassInfoArr = classInfo
        self.standardName = standName
    }

}


