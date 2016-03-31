//
//  SliderMain.swift
//  Craft
//
//  Created by castiel on 15/11/15.
//  Copyright © 2015年 castiel. All rights reserved.
//

import UIKit

class SliderMain: ViewControllerBase , MainMenuProtocol{

    
    var signUpController : SignUp?
    var firstTime : Bool = true
    var distance: CGFloat = 0
    
    var calendar : CalendarView?
    
    let FullDistance: CGFloat = 0.78
    let Proportion: CGFloat = 0.77
    
    var reviewTable : UITableView?
    var reviewTableSource : ReviewTableSource?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.hidden = true
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "showCurrentView:", name: "loginDisappear", object: nil)
        
//        
//        let viewAnimation = CABasicAnimation(keyPath: "position.x")
//        viewAnimation.duration = 0.3
//        viewAnimation.removedOnCompletion = false
//        viewAnimation.timingFunction = CAMediaTimingFunction( name: kCAMediaTimingFunctionEaseOut)
//        viewAnimation.fromValue = UIScreen.mainScreen().bounds.width
//        
//        self.view!.layer.addAnimation(viewAnimation, forKey: nil)
//        self.signUpController!.view!.layer.addAnimation(viewAnimation, forKey: nil)
        
        
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIAdapter.shared.transferWidth(40), height: UIAdapter.shared.transferHeight(20)) )
        menuButton.setTitle("Menu", forState: UIControlState.Normal)
        menuButton.titleLabel!.textColor = UIColor.whiteColor()
        menuButton.addTarget(self, action: "MenuClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: menuButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
    }

    
    func MenuClick(sender : UIButton){
       self.signUpController!.MenuClick()
    }
    
    func showCurrentView(sender : NSNotification){
        if !self.firstTime {
            self.tabBarController?.tabBar.hidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.view.alpha = 1
                }, completion: { (finished) -> Void in
                    self.view.layer.removeAllAnimations()
                    self.tabBarController?.tabBar.hidden = true
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
            })
        }
        self.firstTime = false
    }


    var backGroundImage : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.alpha = 0
        
        let loginView = LoginController(nibName: nil, bundle: nil)
        let loginNav = UINavigationController(rootViewController: loginView)
        self.tabBarController?.presentViewController(loginNav, animated: false, completion: nil)
        
        //透明导航栏
        self.navigationController!.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "navigationBackGround"), forBarMetrics: UIBarMetrics.Default)
        
        
        let backButton = UIBarButtonItem()
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.backBarButtonItem!.title = ""
        
        
        self.signUpController = SignUp(nibName: nil, bundle: nil)
        self.signUpController!.mainMenuProtocal = self
        self.view.addSubview(self.signUpController!.view)
        self.signUpController!.panGesture = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        self.signUpController!.view.addGestureRecognizer(self.signUpController!.panGesture!)

        
    }
    
    override func initView() {
        setBackGroundImage()
        setCalenderActivitiesReview()
        setCalenderView()
    }
    
    func setCalenderActivitiesReview(){
        
        self.reviewTableSource = ReviewTableSource()
        
        self.reviewTable = UITableView(frame: CGRect(x: UIAdapter.shared.transferWidth(10), y: UIAdapter.shared.transferHeight(50) + 64, width: UIAdapter.shared.transferWidth(202), height: UIAdapter.shared.transferHeight(100)))
        self.reviewTable!.dataSource = self.reviewTableSource!
        self.reviewTable!.delegate = self.reviewTableSource!
        self.reviewTable!.showsVerticalScrollIndicator = false
        self.reviewTable!.backgroundColor = UIColor.clearColor()
        self.reviewTable!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.reviewTable!.pagingEnabled = true
        self.view!.addSubview(reviewTable!)
        self.reviewTable!.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6 , 0.6)
        self.reviewTable!.alpha = 0
    }
    
    
    func setBackGroundImage(){
        self.backGroundImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.backGroundImage!.image = UIImage(named: "LoginBackGround")
        self.view.addSubview(backGroundImage!)
    }
    
    
    func setCalenderView(){
         self.calendar = CalendarView(frame: CGRectMake(UIAdapter.shared.transferWidth(15), UIAdapter.shared.transferHeight(170) + 64, UIAdapter.shared.transferWidth(202), UIAdapter.shared.transferHeight(160)))
         self.view.addSubview(self.calendar!)
         self.calendar!.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6 , 0.6)
         self.calendar!.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pan(recongnizer: UIPanGestureRecognizer) {
        
        let x = recongnizer.translationInView(self.view).x
        let trueDistance = distance + x // 实时距离
        
        if trueDistance < 0 {
           return
        }
        
        // 如果 UIPanGestureRecognizer 结束，则激活自动停靠
        if recongnizer.state == UIGestureRecognizerState.Ended {
            
            if trueDistance > Common.screenWidth * (Proportion / 2) {
                showLeft()
                self.navigationController!.setNavigationBarHidden(true, animated: true)
            }else {
                showHome()
                self.navigationController!.setNavigationBarHidden(false, animated: true)
            }
            
            return
        }
        
        // 计算缩放比例
        let direction = recongnizer.view!.frame.origin.x >= 0 ? -1 : 1
        var proportion: CGFloat = recongnizer.view!.frame.origin.x >= 0 ? -1 : 1
        proportion *= trueDistance / Common.screenWidth
        proportion *= 1 - Proportion
        proportion /= 0.87
        proportion += 1
        if proportion <= Proportion { // 若比例已经达到最小，则不再继续动画
            return
        }
        // 执行平移和缩放动画
        
        
        
        recongnizer.view!.center = CGPointMake(self.view.center.x + trueDistance, self.view.center.y)
        recongnizer.view!.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion)
        self.calendar!.transform = CGAffineTransformScale(CGAffineTransformIdentity, (1-proportion) * 2 + 0.6, (1-proportion) * 2 + 0.6)
        self.reviewTable!.transform = CGAffineTransformScale(CGAffineTransformIdentity, (1-proportion) * 2 + 0.6, (1-proportion) * 2  + 0.6)
        
        let current = UIScreen.mainScreen().bounds.width * 0.78 / 22
        
        self.calendar!.alpha = (1 - proportion) * 5
        self.reviewTable!.alpha = (1 - proportion) * 5
        
        self.calendar!.frame.origin.x = (-trueDistance * 0.2 * CGFloat(direction))
        self.reviewTable!.frame.origin.x = (-trueDistance * 0.2 * CGFloat(direction))
       
    }
    
    // 封装三个方法，便于后期调用
    
    // 展示左视图
    func showLeft() {
        distance = self.view.center.x * (FullDistance + Proportion / 2) + UIAdapter.shared.transferWidth(30)
        doTheAnimate(self.Proportion , calendarProportion: 1 , alpha: 1)
    }
    // 展示主视图
    func showHome() {
        distance = 0
        doTheAnimate(1,calendarProportion: 0.6 , alpha: 0)
    }
    
    // 执行三种试图展示
    func doTheAnimate(proportion: CGFloat , calendarProportion : CGFloat , alpha : CGFloat) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.signUpController!.view.center = CGPointMake(self.view.center.x + self.distance , self.view.center.y)
            
            
            self.calendar!.transform = CGAffineTransformScale(CGAffineTransformIdentity, calendarProportion, calendarProportion)
            self.reviewTable!.transform = CGAffineTransformScale(CGAffineTransformIdentity, calendarProportion, calendarProportion)
            
            self.calendar!.alpha = alpha
            self.reviewTable!.alpha = alpha
            
            if alpha > 0{
                self.calendar!.frame.origin.x = UIAdapter.shared.transferWidth(15)
                self.reviewTable!.frame.origin.x = UIAdapter.shared.transferWidth(10)
            }else{
                self.calendar!.frame.origin.x = -UIAdapter.shared.transferWidth(217)
                self.reviewTable!.frame.origin.x = -UIAdapter.shared.transferWidth(212)
            }
            
            
            self.signUpController!.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion)
            }, completion: nil)
    }
    

    func PushNewController(vc : UIViewController){
       self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func ChooseTab(selectIndex : Int){
       self.tabBarController!.selectedIndex =  selectIndex
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
