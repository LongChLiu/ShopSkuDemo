//
//  StandardsView.swift
//  ShopSkuDemo
//
//  Created by zzzsw on 2016/12/1.
//  Copyright © 2016年 sunbohong. All rights reserved.
//

import UIKit


let Screen_Width = UIScreen.main.bounds.size.width
let Screen_Height = UIScreen.main.bounds.size.height


let Height_StandardView = Screen_Height/3*2
let Width_StandardView = Screen_Width


protocol StandardsViewDataSource {



}

protocol StandardsViewDelegate {

    func standardView(standardsView:StandardsView,cusBtnAction:UIButton)
    func standardView(standardsView:StandardsView,btn:UIButton)
    func standardView(standardsView:StandardsView,content:String)
    func standardView(standardsView:StandardsView,selBtnAction:UIButton,selID:String,standName:String,idx:NSInteger)
    //Appear Animation
    func customShowAnimation()
    //Disappear Animation
    func customDismissAnimation()
}

enum StandsViewShowAnimationType : NSInteger {
    case FromBelow = 0,Flash,ShowFromLeft,Custom = 0xFFFF
}

enum StandsViewDismissAnimationType : NSInteger {
    case DisFromBelow = 0,Flash,DisToRight,Custom = 0xFFFF
}








class StandardsView: UIView,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


     let GapToLeft = 20; let GoodDetailScaleValue = 0.9; let ItemsBaseColor = UIColor.white;

    var _cellHeight : CGFloat! = 0
    var _cellNum : NSInteger! = 0
    var cancelBtn : UIButton! = nil
    var sureBtn : UIButton! = nil
    var lineView : UIView! = nil
    var coverView : UIView! = nil
    var showView : UIView! = nil
    var buyNumBackView : UIView! = nil
    var tempImgViewTag : NSInteger! = 0

    lazy var tempImgViewArr : NSMutableArray = {
        var temoA = NSMutableArray()
        return temoA
    }()


    lazy var standardBtnClickDict : NSMutableDictionary = {
        var stanA = NSMutableDictionary()
        return stanA
    }()


    var mainTableView : UITableView! = nil


    lazy var standardBtnArr : NSMutableArray = {
        var stanA = NSMutableArray()
        return stanA
    }()


    var numberTextField : UITextField! = nil



    public var delegate : StandardsViewDelegate! = nil
    public var dataSource : StandardsViewDataSource! = nil


    //Goods brief introduce
    public var mainImgView : UIImageView!
    public var priceLab : UILabel!
    public var goodNum : UILabel!
    public var tipLab : UILabel!



    public var _buyNum : NSInteger!
    public var buyNum : NSInteger!{
        set{
            _buyNum = newValue
            numberTextField.text = "\(newValue)"
        }
        get{
            _buyNum = NSString(string:"\(numberTextField.text)").integerValue
            return _buyNum
        }
    }


    public var _customBtns : [String]!
    public var customBtns : [String]!{
        set{
            _customBtns = newValue
            cancelBtn.removeFromSuperview()
            sureBtn.removeFromSuperview()
            lineView.removeFromSuperview()

            var btnHeight : CGFloat = cancelBtn.frame.size.height
            var btnWidth : CGFloat = Screen_Width / CGFloat(customBtns.count)


            for idx in 0..<_customBtns.count {
                var btn = UIButton(frame:CGRect.init(x: btnWidth*CGFloat(idx), y: Height_StandardView-44, width: btnWidth, height: btnHeight))
                btn.setTitle(_customBtns[idx], for: .normal)
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.addTarget(self, action: #selector(StandardsView.customBtnsClickAction(btn:)), for: .touchUpInside)
                btn.backgroundColor = UIColor.white;btn.tag = 100 + idx
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)

                if idx != _customBtns.count - 1 {
                    var tempLineView = UIView(frame:CGRect.init(x: btnWidth-1, y: 0, width: 1, height: btn.frame.size.height))
                    tempLineView.backgroundColor = UIColor.white
                    btn.addSubview(tempLineView)
                }

                self.delegate.standardView(standardsView: self, btn: btn)
                showView.addSubview(btn)

            }

        }
        get{
            return _customBtns
        }
    }


    func customBtnsClickAction(btn:UIButton){




    }



    public var standardArr : [StandardModel]!{
        didSet{
            mainTableView.reloadData()
        }
    }

    /*
    *   非必须  效果相关
    */
    public var goodDetailView : UIView! = nil
    public var showAnimationType : StandsViewShowAnimationType! = nil
    public var dismissAnimationType : StandsViewDismissAnimationType! = nil

}








extension StandardsView{


    convenience init() {
        self.init()

        self.tempImgViewTag = 0
        self.buildViews()

    }


    func buildViews(){

        frame = self.screenBounds()
        coverView = UIView(frame: self.topView().bounds)
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0
        coverView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        self.topView().addSubview(coverView)

        showView = UIView(frame:CGRect.init(x: 0, y: 0, width: Width_StandardView, height: Height_StandardView))
        showView.center = CGPoint.init(x: frame.size.width/2, y: kScreenHeight-Height_StandardView + Height_StandardView/2)
        showView.layer.masksToBounds = true
        showView.layer.cornerRadius = 5
        showView.backgroundColor = UIColor.white
        self.addSubview(showView)

        mainImgView = UIImageView(frame:CGRect.init(x: GapToLeft, y: 0, width: 100, height: 100))
        mainImgView.layer.cornerRadius = 5
        mainImgView.layer.borderColor = UIColor.white.cgColor
        mainImgView.layer.borderWidth = 3


        mainImgView.center = CGPoint.init(x: 80, y: showView.frame.minY + mainImgView.frame.size.height/3)
        mainImgView.image = UIImage(named:"landou_square_default.png")
        mainImgView.contentMode = .scaleAspectFit
        self.addSubview(mainImgView)

        //默认按键
        cancelBtn = UIButton(frame:CGRect.init(x: 0, y: Height_StandardView-44, width: Width_StandardView/2, height: 44))
        cancelBtn.tag = 1000 + 1;
        cancelBtn.backgroundColor = ItemsBaseColor
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(StandardsView.clickAction(btn:)), for: .touchUpInside)
        showView.addSubview(cancelBtn)


        sureBtn = UIButton(frame:CGRect.init(x: Width_StandardView/2, y: Height_StandardView-44, width: Width_StandardView/2, height: 44))
        sureBtn.tag = 1000 + 2;
        sureBtn.backgroundColor = ItemsBaseColor
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.addTarget(self, action: #selector(StandardsView.clickAction(btn:)), for: .touchUpInside)
        showView.addSubview(sureBtn)



        lineView = UIView(frame:CGRect.init(x: cancelBtn.frame.size.width, y: cancelBtn.frame.origin.y, width: 1, height: cancelBtn.frame.size.height))

        lineView.backgroundColor = UIColor.white
        showView.addSubview(lineView)

        //MARK: 键盘退出手势
        var tepGes = UITapGestureRecognizer(target:self,action:#selector(StandardsView.tapShowViewAction(tap:)))
        showView.addGestureRecognizer(tepGes)

        var tapGes0 = UITapGestureRecognizer(target:self,action:#selector(StandardsView.tapSelfViewAction(tap:)))
        self.addGestureRecognizer(tapGes0)

        goodNum = UILabel();priceLab = UILabel();tipLab = UILabel()

        //购买或加入购物车数量
        numberTextField = UITextField();numberTextField.text = "\(buyNum)"
        numberTextField.font = UIFont.systemFont(ofSize: 14);numberTextField.textColor = UIColor.black;numberTextField.textAlignment = .center;numberTextField.keyboardType = .numberPad

        if buyNum == 0 {
            buyNum = 1
        }
        self.initTableView()

    }


    func initTableView(){

        var tempView = UIView(frame:CGRect.init(x: 0, y: 0, width: Screen_Width, height: 100))
        //最上面显示的信息 数据
        priceLab.frame = CGRect.init(x: mainImgView.frame.maxX+10 , y: 0, width: Screen_Width - (mainImgView.frame.size.width + mainImgView.frame.origin.x) - 10, height: 30)
        priceLab.textColor = UIColor.red
        priceLab.font = UIFont.systemFont(ofSize: 14)
        priceLab.text = "价格"
        tempView.addSubview(priceLab)


        self.goodNum.frame = CGRect.init(x: priceLab.frame.maxX, y: priceLab.frame.maxY, width: priceLab.frame.size.width, height: 30)
        goodNum.textColor = UIColor.black
        goodNum.font = UIFont.systemFont(ofSize: 14)
        goodNum.text = "库存"
        tempView.addSubview(goodNum)


        tipLab.frame = CGRect.init(x: goodNum.frame.minX, y: goodNum.frame.maxY, width: goodNum.frame.size.width, height: 30)
        tipLab.textColor = UIColor.black
        tipLab.font = UIFont.systemFont(ofSize: 14)
        tipLab.text = "请选择 "
        tempView.addSubview(tipLab)


        var HlineView = UIView.init(frame: CGRect.init(x: 10, y: tempView.frame.size.height-1, width: Screen_Width-20, height: 0.5))
        HlineView.backgroundColor = UIColor.gray
        tempView.addSubview(HlineView)
        showView.addSubview(tempView)



        mainTableView = UITableView.init(frame: CGRect.init(x: 0, y: tempView.frame.size.height, width: Width_StandardView, height: Height_StandardView - sureBtn.frame.size.height - tempView.frame.size.height))
        mainTableView.delegate = self;mainTableView.dataSource = self
        mainTableView.separatorColor = UIColor.gray
        mainTableView.separatorStyle = .singleLine
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        mainTableView.tableFooterView = UIView()
        _cellHeight = 100
        showView.addSubview(mainTableView)

    }


    func tapShowViewAction(tap:UITapGestureRecognizer){
        self.endEditing(true)
    }
    func tapSelfViewAction(tap:UIRotationGestureRecognizer){
        self.dismiss()
    }


    func clickAction(btn:UIButton){



    }


    func topView()->UIView{
        let window = UIApplication.shared.keyWindow
        return (window?.subviews[0])!
    }


    func screenBounds()->CGRect{

        var screenWidth = UIScreen.main.bounds.size.width
        var screenHeight = UIScreen.main.bounds.size.height

        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            let interfaceOrientation = UIApplication.shared.statusBarOrientation
            if UIInterfaceOrientationIsLandscape(interfaceOrientation) {
                let tmp = screenWidth
                screenWidth = screenHeight
                screenHeight = tmp
            }
        }
        return CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }

    //MARK: 内部的tableView
    func standardsViewReload(){
        if mainTableView != nil {
            mainTableView.reloadData()
        }
    }



    /*******///MARK: 将商品图片抛到指定点

    /*
     *   将商品抛到指定点
     param destPoint 扔到的点
     *   param height    高度 抛物线最高点比起点/终点y坐标最低(即高度最高)所超出的高度
     *   param duration  动画时间  传0  默认1.6s
     *   param Scale view 变小的比例  传0  默认20
     */
    func throwGood(desPoint:CGPoint,duration:TimeInterval,height:CGFloat,scale:CGFloat){


        var durationU : CGFloat = 0
        var scaleU : CGFloat = 0
        if duration == 0 {
            durationU = 1.6
        }
        if scale == 0 {
            scaleU = 20.0
        }



        

    }

    /*
     *   按比例改变view
     *   param backView 要改变的view
     *   param duration 动画时间
     *   param valuex x缩小的比例
     *   param valueY y缩小的比例
     */
    func setBackViewAnimation(backView:UIView,duration:TimeInterval,valueX:CGFloat,valueY:CGFloat){

        let t : CGAffineTransform = backView.transform
        UIView.animate(withDuration: duration, animations: {_ in

            let tempTrans = t.scaledBy(x: valueX, y: valueY)
            backView.transform = tempTrans

        }, completion: { (finish) in

        })

    }



}





enum ProError : Error {
    case HeightError0
    case HeightError1
    case HeightError2
}

let ViewGapToLine = 20


extension StandardsView{


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.standardArr.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(frame: CGRect.init(x: 0, y: 0, width: Screen_Width, height: _cellHeight))
        if (standardArr == nil || standardArr.count == 0) {
            return cell
        }


        if indexPath.row < standardArr.count {
            let standModel = standardArr[indexPath.row]
            let titleLab = UILabel();titleLab.frame = CGRect.init(x: 10, y: 0, width: Screen_Width, height: 30)
            titleLab.text = standModel.standardName
            titleLab.textColor = UIColor.black;titleLab.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.addSubview(titleLab)

            let oneLineBtnWidthLimit : CGFloat = 300
            let btnGap : CGFloat = 10;let btnGapY : CGFloat = 10
            var btnLineNum : NSInteger = 0;let btnHeight : CGFloat = 30
            let minBtnLength : CGFloat = 50;let maxBtnLength : CGFloat = oneLineBtnWidthLimit - btnGap*2

            var btnX : CGFloat = 0
            btnX += btnGap




            var specArr = standModel.standardClassInfoArr
            let tempArr = NSMutableArray()

            for idx in 0..<specArr!.count {

                let str = (specArr![idx] as standardClassInfo).standardClassName
                var btnWidth = self.width(str: str!, fontSize: 14, height: btnHeight)
                btnWidth += 20

                if btnWidth < minBtnLength {
                    btnWidth = minBtnLength
                }

                if btnWidth > maxBtnLength {
                    btnWidth = maxBtnLength
                }

                if btnX + btnWidth > oneLineBtnWidthLimit {
                    btnLineNum = btnLineNum + 1;
                    btnX = btnGap
                }


                let btn = UIButton(type:.custom)
                let height = titleLab.frame.size.height + titleLab.frame.origin.x + CGFloat(btnLineNum) * (btnHeight + btnGapY)
                btn.frame = CGRect.init(x: btnX, y: height, width: btnWidth, height: btnHeight)
                btn.setTitle(str, for: .normal)
                btn.backgroundColor = UIColor.white
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.layer.cornerRadius = 5
                btn.layer.borderWidth = 0.5
                btn.layer.borderColor = UIColor.gray.cgColor
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.addTarget(self, action: #selector(StandardsView.standardBtnClick(btn:)), for: .touchUpInside)
                let strClassId = (specArr![idx] as standardClassInfo).standardClassId
                let intU : Int = Int(strClassId!.intValue)
                btn.tag = (indexPath.row * 100 + idx)  | (intU << 16)
                let key = "\(indexPath.row)"

                if strClassId!.intValue == NSString(string:standardBtnClickDict[key] as! String).intValue {
                    btn.backgroundColor = UIColor.orange
                }
                tempArr.add(btn)
                btnX = btn.frame.maxX + btnGap
                cell.contentView.addSubview(btn)
            }
            standardBtnArr.add(tempArr)

        }else{

            cell.textLabel?.text = "购买数量"
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)

            let btnWidth : CGFloat = 30
            let plusBtn = UIButton(frame: CGRect.init(x: Screen_Width-CGFloat(10)-btnWidth, y: 0, width: btnWidth, height: 30))
            var tempPoint = plusBtn.center
            plusBtn.addTarget(self, action: #selector(StandardsView.buyNumBtnClick(btn:)), for: .touchUpInside)
            tempPoint.y = _cellHeight/2/2;
            plusBtn.center = tempPoint
            plusBtn.tag = 0
            plusBtn.setImage(UIImage(named:"StandarsAdd"), for: .normal)
            cell.addSubview(plusBtn)

            numberTextField.frame = CGRect.init(x: plusBtn.frame.origin.x - 40, y: plusBtn.center.y-10, width: 40, height: 20)
            numberTextField.textAlignment = .center
            numberTextField.backgroundColor = UIColor.gray
            cell.addSubview(numberTextField)


            let reduceBtn = UIButton(frame:CGRect.init(x: numberTextField.frame.origin.x - btnWidth, y: plusBtn.center.y - plusBtn.frame.size.height/2, width: plusBtn.frame.size.width, height: plusBtn.frame.size.height))
            reduceBtn.addTarget(self, action: #selector(StandardsView.buyNumBtnClick(btn:)), for: .touchUpInside)
            reduceBtn.setImage(UIImage(named:"StandarsDel"), for: .normal)
            reduceBtn.tag = 1;
            cell.addSubview(reduceBtn)

        }

        return cell

    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == standardArr.count {
            return _cellHeight/2
        }

        var totalHeight : CGFloat = 0;

        let oneLineBtnWidtnLimit : CGFloat = 300;//每行btn占的最长长度，超出则换行
        let btnGap : CGFloat = 10;//btn的x间距
        let btnGapY : CGFloat = 10;
        var BtnlineNum : NSInteger = 0;
        let BtnHeight : CGFloat = 30;
        let minBtnLength : CGFloat =  50;//每个btn的最小长度
        let maxBtnLength : CGFloat = oneLineBtnWidtnLimit - btnGap*2;//每个btn的最大长度
        var Btnx : CGFloat! //每个btn的起始位置
        Btnx = Btnx + btnGap;



        let count = (standardArr[indexPath.row] as StandardModel).standardClassInfoArr.count
        for idx in 0 ..< count {

            let str = (standardArr[indexPath.row].standardClassInfoArr[idx]).standardClassName
            var btnWidth = self.width(str: str!, fontSize: 14, height: BtnHeight)

            btnWidth = btnWidth + 20

            if(btnWidth<minBtnLength){
                btnWidth = minBtnLength;
            }

            if(btnWidth>maxBtnLength){
                btnWidth = maxBtnLength;
            }


            if(Btnx + btnWidth > oneLineBtnWidtnLimit)
            {
                BtnlineNum = BtnlineNum + 1;//长度超出换到下一行
                Btnx = btnGap;
            }

            Btnx = Btnx + btnWidth + btnGap;

        }

        totalHeight = CGFloat(30) + (CGFloat(1)+CGFloat(BtnlineNum))*(BtnHeight+btnGapY) + btnGapY;

        if totalHeight == 0 {
            return _cellHeight
        }

        return totalHeight;
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }


    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }



    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let tempView = UIView()
        return tempView

    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }






    func standardBtnClick(btn:UIButton){




    }

    func buyNumBtnClick(btn:UIButton){




    }



    func width(str:String,fontSize:CGFloat,height:CGFloat)->CGFloat{
        let attrs = [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)]
        return NSString(string:str).boundingRect(with: CGSize.init(width: 0, height: height), options: [.truncatesLastVisibleLine,.usesLineFragmentOrigin,.usesFontLeading], attributes: attrs, context: nil).size.width
    }


}





extension StandardsView{



    func showAnimation(){

        switch self.showAnimationType.rawValue {

        case StandsViewShowAnimationType.Flash.rawValue:


            let popAnimation = CAKeyframeAnimation(keyPath: "transform")

            popAnimation.duration = 0.4
            popAnimation.values = [
                                    NSValue.init(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0)),
                                    NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
                                    NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
                                    NSValue.init(caTransform3D:CATransform3DIdentity)
            ]
            popAnimation.keyTimes = [0.2,0.5,0.75,1.0]
            popAnimation.timingFunctions = [
                                    CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
                                    CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
                                    CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
            ]

            showView.layer.add(popAnimation, forKey: nil)
            mainImgView.layer.add(popAnimation, forKey: nil)

            if goodDetailView != nil {

                weak var weakSelf : StandardsView! = self
                var t = self.goodDetailView.transform
                UIView.animate(withDuration: 1.0, animations: {

                    let tempTransform = t.scaledBy(x: CGFloat(weakSelf.GoodDetailScaleValue), y: CGFloat(weakSelf.GoodDetailScaleValue))
                    self.goodDetailView.transform = tempTransform

                })
            }

            break

        case StandsViewShowAnimationType.FromBelow.rawValue:

            var t : CGAffineTransform!
            if goodDetailView != nil {
                t = goodDetailView.transform
            }

            let mainImgCenter = mainImgView.center

            mainImgView.center = CGPoint.init(x: mainImgCenter.x, y: mainImgCenter.y + Screen_Height)

            let tempPoint = showView.center
            showView.center = CGPoint.init(x: Screen_Width/2, y: tempPoint.y+Screen_Height)

            weak var weakSelf : StandardsView! = self
            UIView.animate(withDuration: 0.5, animations: {
                weakSelf.showView.center = tempPoint
                weakSelf.mainImgView.center = mainImgCenter
                if weakSelf.goodDetailView != nil {

                    let tempTransform = t.scaledBy(x: CGFloat(weakSelf.GoodDetailScaleValue), y: CGFloat(weakSelf.GoodDetailScaleValue))
                    weakSelf.goodDetailView.transform = tempTransform


                }
            })

            break
        case StandsViewShowAnimationType.ShowFromLeft.rawValue:

            self.selfShowAnimationFromLeft()

            break

        case StandsViewShowAnimationType.Custom.rawValue:

            self.delegate.customShowAnimation()

            break

        default:

            break

        }

    }








    func selfShowAnimationFromLeft(){

        let tempRect = showView.frame
        showView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 2.0)
        showView.frame = tempRect
        showView.transform = CGAffineTransform.init(rotationAngle: -(CGFloat)(M_PI_4))
        let tempPoint = mainImgView.center
        mainImgView.center = CGPoint.init(x: tempPoint.x, y: 0)
        var t : CGAffineTransform!
        if self.goodDetailView != nil {
            t = self.goodDetailView.transform
        }

        weak var weakSelf : StandardsView! = self
        UIView.animate(withDuration: 0.5, animations: { (finished )in

            weakSelf?.mainImgView.center = tempPoint
            weakSelf?.showView.transform = CGAffineTransform.identity

            if (weakSelf?.goodDetailView != nil) {
                let tempTransform = t.scaledBy(x: CGFloat(weakSelf.GoodDetailScaleValue), y: CGFloat(weakSelf.GoodDetailScaleValue))
                weakSelf.goodDetailView.transform = tempTransform
            }

        })
    }


    func selfDismissAnimationToRight(){

        let tempRect = showView.frame
        showView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 2.0)
        showView.frame = tempRect

        let tempPoint = self.mainImgView.center
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: { void in

            weakSelf?.mainImgView.center = CGPoint.init(x: tempPoint.x, y: Screen_Height)
            weakSelf?.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI_4))
            weakSelf?.alpha = 0.0

            var t : CGAffineTransform!
            if weakSelf?.goodDetailView != nil {
                t = weakSelf?.goodDetailView.transform
            }

            if weakSelf?.goodDetailView != nil {
                let tempTransform = t.scaledBy(x: CGFloat(1)/CGFloat((weakSelf?.GoodDetailScaleValue)!), y: CGFloat(1)/CGFloat((weakSelf?.GoodDetailScaleValue)!))
                weakSelf?.goodDetailView.transform = tempTransform
            }


        }, completion:{(finished) in

            weakSelf?.showView.alpha = 0.0
            weakSelf?.removeFromSuperview()

        })


    }




    func hideAnimation(){

        switch self.dismissAnimationType.rawValue {
        case StandsViewDismissAnimationType.Flash.rawValue:

            var t : CGAffineTransform!
            if self.goodDetailView != nil {
                t = self.goodDetailView.transform
            }

            weak var weakSelf : StandardsView! = self
            UIView.animate(withDuration: 0.5, animations: { 
                weakSelf.alpha = 0.0
                weakSelf.showView.alpha = 0.0
                weakSelf.mainImgView.alpha = 0.0

                if weakSelf.goodDetailView != nil {
                    let tempTransform = t.scaledBy(x: CGFloat(1)/CGFloat(weakSelf.GoodDetailScaleValue), y: CGFloat(1)/CGFloat(weakSelf.GoodDetailScaleValue))
                    weakSelf.goodDetailView.transform = tempTransform
                }

            }, completion: { (finished) in

                self.removeFromSuperview()

            })


            break
        case StandsViewDismissAnimationType.DisFromBelow.rawValue:


            var t : CGAffineTransform!
            if self.goodDetailView != nil {
                t = self.goodDetailView.transform
            }

            weak var weakSelf : StandardsView! = self
            UIView.animate(withDuration: 0.5, animations: {

                let mainImgCenter = weakSelf.mainImgView.center
                weakSelf.mainImgView.center = CGPoint.init(x: mainImgCenter.x, y: mainImgCenter.y + Screen_Height)

                let tempPoint = weakSelf.showView.center

                weakSelf.showView.center = CGPoint.init(x: Screen_Width/2, y: tempPoint.y + Screen_Height)
                if weakSelf.goodDetailView != nil {
                    let tempTransform = t.scaledBy(x: CGFloat(1)/CGFloat(weakSelf.GoodDetailScaleValue), y: CGFloat(1)/CGFloat(weakSelf.GoodDetailScaleValue))
                    weakSelf.goodDetailView.transform = tempTransform
                }

                weakSelf.coverView.alpha = 0.0
                weakSelf.showView.alpha = 0.0


            }, completion: { (finished) in

                self.removeFromSuperview()
                
            })
            
            
            break
        case StandsViewDismissAnimationType.DisToRight.rawValue:

            self.selfDismissAnimationToRight()
            
            break
        case StandsViewDismissAnimationType.Custom.rawValue:

            self.delegate.customDismissAnimation()
            
            break
        default:
            break
        }

    }



    //关闭显示
    func dismiss(){
        //清除抛物创建的views
        if self.tempImgViewArr.count > 0 {
            for imgV  in self.tempImgViewArr {
                let imgU : UIImageView! = imgV as! UIImageView
                if imgU != nil && imgU.superview != nil {
                    imgU.alpha = 0
                    imgU.removeFromSuperview()
                }
            }
            self.tempImgViewArr.removeAllObjects()
        }
        self.hideAnimation()
        self.endEditing(true)
    }

    //MARK: 显示规格
    func show(){

        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {_ in

            weakSelf?.alpha = 0.5

        }, completion: {(finished) in

        })

        self.topView().addSubview(self)
        self.showAnimation()

    }



    func showAnimationFromLeft(view:UIView){

        let tempRect = view.frame
        view.layer.anchorPoint = CGPoint.init(x: 0.5, y: 2.0)
        view.frame = tempRect
        view.transform = CGAffineTransform.init(rotationAngle: -(CGFloat)(M_PI_4))

        UIView.animate(withDuration: 1.0, animations: {_ in

            view.transform = CGAffineTransform.identity

        }, completion: {(finished) in

        })

    }


}
















