//
//  GoodsDetailVC.swift
//  ShopSkuDemo
//
//  Created by zzzsw on 2016/12/1.
//  Copyright © 2016年 sunbohong. All rights reserved.
//

import UIKit


let kScreenHeight = UIScreen.main.bounds.size.height

class GoodsDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.contentMode = .center
        view.backgroundColor = UIColor.blue

        let tempBtn0 = UIButton(type: .custom)
        tempBtn0.frame = CGRect(x: 10, y: kScreenHeight-100, width: 60, height: 44)
        tempBtn0.tag = 0
        tempBtn0.setImage(UIImage(named:"gril"), for: .normal)
        tempBtn0.addTarget(self, action: #selector(GoodsDetailVC.btnAction(btn:)), for: .touchUpInside)
        view.addSubview(tempBtn0)

        let tempBtn1 = UIButton(type: .custom)
        tempBtn1.frame = CGRect(x: tempBtn0.frame.maxX+10, y: kScreenHeight-100, width: 60, height: 44)
        tempBtn1.tag = 1
        tempBtn1.setImage(UIImage(named:"gril"), for: .normal)
        tempBtn1.addTarget(self, action: #selector(GoodsDetailVC.btnAction(btn:)), for: .touchUpInside)
        view.addSubview(tempBtn1)

        let tempBtn2 = UIButton(type: .custom)
        tempBtn2.frame = CGRect(x: tempBtn1.frame.maxX + 10, y: kScreenHeight-100, width: 60, height: 44)
        tempBtn2.tag = 2
        tempBtn2.setImage(UIImage(named:"gril"), for: .normal)
        tempBtn2.addTarget(self, action: #selector(GoodsDetailVC.btnAction(btn:)), for: .touchUpInside)
        view.addSubview(tempBtn2)

    }

    func btnAction(btn:UIButton){


        if btn.tag == 0 {


        }

        if btn.tag == 1 {

            
        }

        if btn.tag == 2 {

            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
