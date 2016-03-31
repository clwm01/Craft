//
//  ReviewTableSource.swift
//  Craft
//
//  Created by castiel on 16/3/15.
//  Copyright © 2016年 castiel. All rights reserved.
//

import Foundation

class ReviewTableSource : NSObject , UITableViewDataSource , UITableViewDelegate {
    
    var cellHeight : CGFloat?
    var name : String?
    override init() {
        super.init()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reviewTableCell") as? reviewTableCell
        if(cell == nil) {
            
            cell = reviewTableCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reviewTableCell", cellHeight: UIAdapter.shared.transferHeight(100) , lineColor: Resources.Color.goldenEdge)
            
        }
        

        cell!.backgroundColor = UIColor.clearColor()
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell!.setTopLineHide()
        cell!.setBottomLineHide()
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIAdapter.shared.transferHeight(100)
    }
}