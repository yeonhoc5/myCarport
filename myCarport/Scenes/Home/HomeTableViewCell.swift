
//
//  HomeTableViewCell.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/01.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet var lblItemName: UILabel!
    @IBOutlet var lblCycle: UILabel!
    @IBOutlet var lblLastMileage: UILabel!
    @IBOutlet var lblPeriod: UILabel!
    @IBOutlet var viewGraphStick: UIView!
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            let inset: CGFloat = 15
            var frame = newFrame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            super.frame = frame
        }
    }    
    
}
