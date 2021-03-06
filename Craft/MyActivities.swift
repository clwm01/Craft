//
//  MyActivities.swift
//  Craft
//
//  Created by castiel on 16/2/23.
//  Copyright © 2016年 castiel. All rights reserved.
//

import UIKit

class MyActivities: ViewControllerBase ,UIGestureRecognizerDelegate , UITableViewDataSource, UITableViewDelegate{
    
    
    var activitiesView : UIImageView?
    var cancelView : UIImageView?
    var button : UIButton?
    var blankTap : UITapGestureRecognizer?
    
    
    var scroll : UIScrollView?
    var table : UITableView?
    
    var raidDropdown : UIButton?
    var raidTitle : UITextView?
    var raidContent : UITextView?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController!.navigationBar.barStyle = UIBarStyle.BlackTranslucent
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "navigationBackGround"), forBarMetrics: UIBarMetrics.Default)
        
        self.navigationController!.setNavigationBarHidden(true, animated: false)

        let animation = CASpringAnimation(keyPath: "position.x")
        animation.damping = 12
        animation.stiffness = 100
        animation.mass = 1
        animation.initialVelocity = 0
        animation.duration = animation.settlingDuration
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction( name: kCAMediaTimingFunctionEaseOut)
        animation.fromValue = -UIAdapter.shared.transferWidth(150)

        self.activitiesView!.layer.addAnimation(animation, forKey: nil)
        
        
        let cancelAnimation = CASpringAnimation(keyPath: "position.x")
        cancelAnimation.damping = 12
        cancelAnimation.stiffness = 100
        cancelAnimation.mass = 1
        cancelAnimation.initialVelocity = 0
        cancelAnimation.duration = animation.settlingDuration
        cancelAnimation.removedOnCompletion = false
        cancelAnimation.timingFunction = CAMediaTimingFunction( name: kCAMediaTimingFunctionEaseOut)
        cancelAnimation.fromValue = UIAdapter.shared.transferWidth(150) + UIScreen.mainScreen().bounds.width

        self.cancelView!.layer.addAnimation(cancelAnimation, forKey: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
             // Do any additional setup after loading the view.
    }
    
    override func initView() {
        setActivitiesView()
        setScroll()
        setBlaBlaControls()
        setRaidMember()
        setCancelView()
        setTapForBackgroundView()
    }
   
    
    func setTapForBackgroundView(){
         self.blankTap = UITapGestureRecognizer(target: self, action: #selector(MyActivities.BlankSpaceTap(_:)))
         self.blankTap!.numberOfTapsRequired = 1
         self.blankTap!.delegate = self
         self.view.addGestureRecognizer(self.blankTap!)
    }
    
    func BlankSpaceTap(sender : UITapGestureRecognizer){
    
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.activitiesView!.frame.origin.x = -UIAdapter.shared.transferWidth(300)
            self.cancelView!.frame.origin.x = UIAdapter.shared.transferWidth(280) + UIScreen.mainScreen().bounds.width
            }) { (success) -> Void in
                if success {
                   self.dismissViewControllerAnimated(false, completion: { () -> Void in
                      NSNotificationCenter.defaultCenter().postNotificationName("dismissAcitivtiesDialog", object: self)
                   })
                    
                }
        }
    }
    
    
    func setScroll(){
        
        self.scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIAdapter.shared.transferWidth(240), height: UIAdapter.shared.transferHeight(300)))
        self.scroll!.contentSize = CGSize(width: UIAdapter.shared.transferWidth(240) , height: UIAdapter.shared.transferHeight(500))
        self.scroll?.backgroundColor = UIColor.brownColor()
        self.activitiesView!.addSubview(self.scroll!)
        
        self.scroll?.mas_makeConstraints{ make in
           make.top.equalTo()(self.activitiesView!.mas_top).with().offset()(UIAdapter.shared.transferHeight(25))
           make.bottom.equalTo()(self.activitiesView!).with().offset()( -UIAdapter.shared.transferHeight(15) )
           make.left.equalTo()(self.activitiesView!).with().offset()(UIAdapter.shared.transferWidth(20))
           make.right.equalTo()(self.activitiesView!).with().offset()(UIAdapter.shared.transferWidth(-20))
        }
    }
    
    func setBlaBlaControls(){
        self.raidDropdown = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        self.raidDropdown!.backgroundColor = UIColor.blackColor()
        self.raidDropdown!.setTitle("副本", forState: UIControlState.Normal)
        self.raidDropdown?.addTarget(self, action: "raidDropDown:", forControlEvents: UIControlEvents.TouchUpInside)
        self.scroll!.addSubview(self.raidDropdown!)
        
        self.raidTitle = UITextView(frame: CGRect(x: 0, y: 60, width: 200, height: 50))
        self.raidTitle!.backgroundColor = UIColor.blackColor()
        self.scroll!.addSubview(self.raidTitle!)
        
        self.raidContent = UITextView(frame: CGRect(x: 0, y: 120, width: 200, height: 100))
        self.raidContent!.backgroundColor = UIColor.blackColor()
        self.scroll!.addSubview(self.raidContent!)

    }
    
    func raidDropDown(sender : UIButton){
        
        let dropDown = DropDownSelection(nibName: nil, bundle: nil)
        dropDown.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext

        self.presentViewController(dropDown, animated: true, completion: nil)
    }
    
    
    func setRaidMember(){
           self.table = UITableView(frame: CGRect(x: 30, y: 270, width: 400, height: 300))
           self.table!.backgroundColor = UIColor.blueColor()
        
           self.scroll!.addSubview(self.table!)
           self.table!.delegate = self
           self.table!.dataSource = self
        
    }
    
    func setActivitiesView(){
        self.activitiesView = UIImageView(frame: CGRect(x: 0, y: 64 + UIAdapter.shared.transferHeight(15), width: UIAdapter.shared.transferWidth(280), height: UIAdapter.shared.transferHeight(340)))
        self.activitiesView!.userInteractionEnabled = true
        self.activitiesView!.backgroundColor = UIColor(red: 30/255, green: 69/255, blue: 102/255, alpha: 1)
        self.activitiesView!.alpha = 0.7
        self.activitiesView!.layer.cornerRadius = 5
        self.activitiesView!.layer.borderWidth = 2
        self.activitiesView!.layer.borderColor = UIColor.grayColor().CGColor
        self.activitiesView!.layer.masksToBounds = true
        self.view.addSubview(self.activitiesView!)
        
        


    }
    
    func setCancelView(){
        self.cancelView = UIImageView(frame: CGRect(x: 0, y: 64 + UIAdapter.shared.transferHeight(15), width: UIAdapter.shared.transferWidth(300), height: UIAdapter.shared.transferHeight(400)))
        self.cancelView!.userInteractionEnabled = true
        self.cancelView!.backgroundColor = UIColor(red: 30/255, green: 69/255, blue: 102/255, alpha: 1)
        self.cancelView!.layer.cornerRadius = 5
        self.cancelView!.layer.borderWidth = 2
        self.cancelView!.layer.borderColor = UIColor.grayColor().CGColor
        self.cancelView!.layer.masksToBounds = true
        self.view.addSubview(self.cancelView!)
        
        self.cancelView!.hidden = true
        
        self.cancelView!.mas_makeConstraints{ make in
           make.right.equalTo()(self.view)
           make.left.equalTo()(self.view.mas_right).with().offset()(UIAdapter.shared.transferWidth(-100))
           make.top.equalTo()(self.activitiesView!.mas_bottom).with().offset()(UIAdapter.shared.transferHeight(10))
           make.bottom.equalTo()(self.activitiesView!.mas_bottom).with().offset()(UIAdapter.shared.transferHeight(35))
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {

        let point = touch.locationInView(gestureRecognizer.view)
        
        if CGRectContainsPoint(self.activitiesView!.frame, point){
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if(cell == nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        }
        
        cell!.imageView!.image = UIImage(named: "alliance")
        cell!.textLabel!.text = "This is test label"
        cell!.detailTextLabel!.text = "This is test description label"
        cell!.backgroundColor = UIColor.clearColor()
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIAdapter.shared.transferHeight(50)
    }
    
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var rotation = CATransform3DMakeRotation( CGFloat(0.3 * M_PI) , 0.0, 0.5, 0.0);
        rotation.m34 = 1.0 / -600;
        
        
        //2. Define the initial state (Before the animation)
//        cell.layer.shadowColor = UIColor.blackColor().CGColor
//        cell.layer.shadowOffset = CGSizeMake(10, 10);
        
        cell.layer.transform = rotation;
        cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        
        UIView.beginAnimations("rotation", context: nil)
        UIView.setAnimationDuration(0.8)
        //3. Define the final state (After the animation) and commit the animation
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        UIView.commitAnimations()
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
