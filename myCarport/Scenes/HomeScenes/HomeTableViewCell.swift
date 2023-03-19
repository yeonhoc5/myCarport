
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
    @IBOutlet var lblPeriodStart: UILabel!
    @IBOutlet var lblPeriodEnd: UILabel!
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
        lblPeriodStart.isHidden = periodHidden
        lblPeriodEnd.isHidden = periodHidden
        switch type {
        case .empty:
            lblItemName.text = strEmpty
            lblPeriodStart.text = "--/--/--"
            lblPeriodEnd.text = "~ --/--/--"
        case .last:
            lblItemName.text = "\(insurance?.corpName ?? "__")"
            lblPeriodStart.text = "\(Funcs.formatteredDate(date: insurance?.dateStart ?? Date()))"
            lblPeriodEnd.text = "~ \(Funcs.formatteredDate(date: insurance?.dateEnd ?? Date()))"
        }
        lblItemName.font = .systemFont(ofSize: 17, weight: .semibold)
        lblItemName.textColor = .label
        [lblPeriodStart, lblPeriodEnd].forEach({
            $0.font = .systemFont(ofSize: 13, weight: .medium)
            $0.textColor = .secondaryLabel
        })
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
            lblLastMileage.text = "(last: \(Funcs.addCommaToNumber(number: lastHistory.mileage)) km)"
        }
        lblItemName.font = .systemFont(ofSize: 17, weight: .semibold)
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
