//
//  InsuranceCell.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit
import SnapKit

class InsuranceCell: UITableViewCell {
    
    enum InsuranceStatue {
        case isNil, empty, last
    }
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDateStart: UILabel!
    @IBOutlet var lblDateEnd: UILabel!
    @IBOutlet var lblCallNumber: UILabel!
    
    var idOfCar: Int!
    
    func settingCellCorp(type: InsuranceStatue, strEmpty: String! = "", insurance: Insurance! = nil) {
            switch type {
            case .isNil:
                lblTitle.text = "-- 보험"
                lblTitle.textColor = .label
                lblDateStart.text = "0000-00-00"
                lblDateEnd.text = "~ 0000-00-00"
                [lblDateStart, lblDateEnd].forEach {
                    $0.isHidden = false
                    $0.textColor = .label
                }
            case .empty:
                lblTitle.text = strEmpty
                lblTitle.textColor = .secondaryLabel
                lblDateStart.isHidden = true
                lblDateEnd.isHidden = true
            default:
                lblTitle.text = "\(insurance.corpName ?? "")"
                lblTitle.textColor = .label
                lblDateStart.text = "\(Funcs.formatteredDate(date: insurance.dateStart!))"
                lblDateEnd.text = "~ \(Funcs.formatteredDate(date: insurance.dateEnd!))"
                [lblDateStart, lblDateEnd].forEach {
                    $0.isHidden = false
                    $0.textColor = .label
                }
            }
    }
    
    func settingCellMileage(type: InsuranceStatue, insurance: Insurance! = nil) {
        lblTitle.text = "(등록 시 주행거리)"
        lblTitle.textColor = .secondaryLabel
        lblDateStart.textColor = .secondaryLabel
        switch type {
        case .isNil, .empty:
            lblDateStart.text = "-- km"
        default:
            lblDateStart.text = "\(Funcs.addCommaToNumber(number: insurance.mileageContract)) km"
        }
    }
    
    func settingCellPay(type: InsuranceStatue, insurance: Insurance! = nil) {
        lblTitle.text = "(결제금)"
        lblTitle.textColor = .secondaryLabel
        lblDateStart.textColor = .secondaryLabel
        switch type {
        case .isNil, .empty:
            lblDateStart.text = "-- 원"
        default:
            lblDateStart.text = "\(Funcs.addCommaToNumber(number: insurance.payContract)) 원"
        }
    }
    func settingCellCall(type: InsuranceStatue, insurance: Insurance! = nil) {
        
        switch type {
        case .isNil, .empty:
            lblCallNumber.text = "0000-0000"
            lblCallNumber.textColor = .secondaryLabel
        default:
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let index = appDelegate.insuranceCorp.firstIndex(where: { $0.name == insurance?.corpName }) {
                let front = appDelegate.insuranceCorp[index].callNumber / 10000
                let back = appDelegate.insuranceCorp[index].callNumber % 10000
                lblCallNumber.text = "\(front)-\(back < 1000 ? "0" : "")\(back)"
            }
            lblCallNumber.textColor = .btnTealBackground
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

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
