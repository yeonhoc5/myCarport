
//
//  HomeTableViewCell.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/01.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    enum ContenType {
        case empty, last
    }
    
    @IBOutlet var lblItemName: UILabel!
    @IBOutlet var lblCycle: UILabel!
    @IBOutlet var lblLastMileage: UILabel!
    @IBOutlet var lblPeriod: UILabel!
    @IBOutlet var viewGraphStick: UIView!
    
    // graph setting properties
    var compareValue: Int!
    var currenValue: Int!
    var historyCount: Int! = 0
    
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
    
    func settingInsurance(type: ContenType, periodHidden: Bool! = false, strEmpty: String! = "--", insurance : Insurance! = nil) {
        lblPeriod.isHidden = periodHidden
        switch type {
        case .empty:
            lblItemName.text = strEmpty
            lblPeriod.text = "0000-00-00\n~ 0000-00-00"
        case .last:
            lblItemName.text = "\(insurance.corpName)"
            lblPeriod.text = "\(Funcs.formatteredDate(date: insurance.dateStart))\n~\(Funcs.formatteredDate(date: insurance.dateEnd))"
        }
        lblItemName.font = .systemFont(ofSize: 17, weight: .semibold, width: .condensed)
        lblItemName.textColor = .label
        lblPeriod.font = .systemFont(ofSize: 13, weight: .medium)
        lblPeriod.textColor = .secondaryLabel
        lblPeriod.numberOfLines = 2
        lblPeriod.textAlignment = .left
        lblPeriod.sizeToFit()
    }
    
    func settingItem(type: ContenType, lastHidden: Bool! = false, itemName: String, strEmpty: String! = "--", lastHistory: ManageHistory! = nil, gapMileage: Int! = nil, cycle: Int! = nil) {
        lblItemName.text = "\(itemName)"
        lblLastMileage.isHidden = lastHidden
        switch type {
        case .empty:
            lblCycle.text = strEmpty
            lblLastMileage.text = "(last: \(strEmpty ?? "--") km)"
        case .last:
            lblCycle.text = gapMileage < cycle ? "\(cycle - gapMileage) km 남음" : "\(-(cycle - gapMileage)) km 초과"
            lblLastMileage.text = "(last: \(lastHistory.mileage) km)"
        }
        lblItemName.font = .systemFont(ofSize: 17, weight: .semibold, width: .condensed)
        lblItemName.textColor = .label
        lblCycle.font = .systemFont(ofSize: 15, weight: .medium)
        lblCycle.textColor = .secondaryLabel
        lblLastMileage.font = .systemFont(ofSize: 12, weight: .medium)
        lblLastMileage.textColor = .secondaryLabel
    }
    
    func settingGraph() {
        UIView.animate(withDuration: 1, delay: 0) {
            self.viewGraphStick.frame.size.width = self.currenValue < self.compareValue ? self.frame.width * CGFloat(self.currenValue) / CGFloat(self.compareValue) : self.frame.width
            self.viewGraphStick.backgroundColor = self.currenValue < self.compareValue ? .systemTeal.withAlphaComponent(0.4) : .systemPink.withAlphaComponent(0.5)
        }
    }
    
}
