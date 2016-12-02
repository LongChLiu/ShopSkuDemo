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

    init(class_Id:String,stand_ClassName:String){


        //self.init()

        self.standardClassId = class_Id as NSString!
        self.standardClassName = stand_ClassName
    }

//    convenience init(class_Id:String,stand_ClassName:String){
//
//
//        self.init()
//
//        self.standardClassId = class_Id as NSString!
//        self.standardClassName = stand_ClassName
//    }




    class func standard_ClassInfo(classId:String,standClassName:String)->standardClassInfo{

        let obj = standardClassInfo(class_Id: classId, stand_ClassName: standClassName)

        return obj
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


