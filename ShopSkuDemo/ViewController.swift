//
//  ViewController.swift
//  ShopSkuDemo
//
//  Created by zzzsw on 2016/12/1.
//  Copyright © 2016年 sunbohong. All rights reserved.
//

import UIKit

let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController,StandardsViewDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.red


        let tempBtn1 = UIButton.init(frame: CGRect.init(x: 10, y: kScreenHeight-100, width: 60, height: 44))
        tempBtn1.tag = 0
        tempBtn1.setImage(UIImage(named:"gril"), for: .normal)
        tempBtn1.addTarget(self, action: #selector(ViewController.btnAction(btn:)), for: .touchUpInside)
        view.addSubview(tempBtn1)



        let tempBtn2 = UIButton.init(frame: CGRect.init(x: tempBtn1.frame.maxX+10, y: Screen_Height-100, width: 60, height: 44))
        tempBtn2.tag = 1
        tempBtn2.setImage(UIImage(named:"butterfly"), for: .normal)
        tempBtn2.addTarget(self, action: #selector(ViewController.btnAction(btn:)), for: .touchUpInside)
        view.addSubview(tempBtn2)


        let tempBtn3 = UIButton.init(frame: CGRect.init(x: tempBtn2.frame.maxX+10, y: Screen_Height-100, width: 60, height: 44))
        tempBtn3.tag = 2
        tempBtn3.setImage(UIImage(named:"yellowBee"), for: .normal)
        tempBtn3.addTarget(self, action: #selector(ViewController.btnAction(btn:)), for: .touchUpInside)
        view.addSubview(tempBtn3)


    }


    func btnAction(btn:UIButton){


        let myStandardView = self.buildStandardView(img: (btn.imageView?.image)!, index: btn.tag)
        myStandardView.goodDetailView = self.view


        if btn.tag == 0 {
            myStandardView.showAnimationType = StandsViewShowAnimationType.FromBelow
            myStandardView.dismissAnimationType = StandsViewDismissAnimationType.DisFromBelow
        }

        if btn.tag == 1 {
            myStandardView.showAnimationType = StandsViewShowAnimationType.Flash
            myStandardView.dismissAnimationType = StandsViewDismissAnimationType.Flash
        }

        if btn.tag == 2 {
            myStandardView.showAnimationType = StandsViewShowAnimationType.ShowFromLeft
            myStandardView.dismissAnimationType = StandsViewDismissAnimationType.DisToRight
        }

        myStandardView.show()

    }



    func buildStandardView(img:UIImage,index:NSInteger)->StandardsView{
        let standView = StandardsView(frame:CGRect.zero)
        standView.tag = index
        standView.delegate = self

        standView.mainImgView.image = img
        standView.mainImgView.backgroundColor = UIColor.cyan
        standView.priceLab.text = "￥100.0"
        standView.tipLab.text = "请选择规格"
        standView.goodNum.text = "库存 10件"


        standView.customBtns = ["加入购物车","立即购买"]



        let tempClassInfo1 = standardClassInfo.init(class_Id: "100", stand_ClassName: "红色")
        let tempClassInfo2 = standardClassInfo.init(class_Id: "101", stand_ClassName: "蓝色")
        let tempClassInfoArr = [tempClassInfo1,tempClassInfo2]
        let tempModel = StandardModel.standardModel(classInfo: tempClassInfoArr, standName: "颜色")


        let tempClassInfo3 = standardClassInfo.standard_ClassInfo(classId: "102", standClassName: "XL")
        let tempClassInfo4 = standardClassInfo.standard_ClassInfo(classId: "103", standClassName: "XXL")
        let tempClassInfo5 = standardClassInfo.standard_ClassInfo(classId: "104", standClassName: "XXXL")
        let tempClassInfoArr2 = [tempClassInfo3,tempClassInfo4,tempClassInfo5]
        let tempModel2 = StandardModel.standardModel(classInfo: tempClassInfoArr2, standName: "尺寸")

        
        standView.standardArr = [tempModel,tempModel2]

        return standView

    }


    //MARK:  standardView Delegate

    /*自定义按键*/
    func standardView(standardsView: StandardsView, cusBtnAction: UIButton) {

        if cusBtnAction.tag == 0 {
            //将商品图片抛到指定点
            standardsView.throwGood(desPoint: CGPoint.init(x: 200, y: 100), duration: 1.6, height: 150, scale: 20)

        }else{
            standardsView.dismiss()
        }

    }


    /*点击规格代理*/
    func standardView(standardsView: StandardsView, selBtnAction: UIButton, selID: String, standName: String, idx: NSInteger) {

        NSLog("selectID = %@  standName = %@  index = %ld", selID,standName,idx)


    }

    //设置自定义Btn的属性
    func standardView(standardsView: StandardsView, btn: UIButton) {

        if btn.tag - 100 == 0 {
            btn.backgroundColor = UIColor.yellow
        }else if(btn.tag - 100 == 1){
            btn.backgroundColor = UIColor.orange
        }

    }










    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

