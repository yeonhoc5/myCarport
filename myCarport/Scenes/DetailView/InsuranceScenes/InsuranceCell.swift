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
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnTelNum: UIButton!
    @IBOutlet var btnTelEdit: UIButton!
    
    var idOfCar: Int!
    
    func settingCellCorp(type: InsuranceStatue, strEmpty: String! = "", insurance: Insurance! = nil) {
        switch type {
        case .isNil:
            lblSubTitle.isHidden = false
            lblTitle.textColor = .label
            lblSubTitle.textColor = .label
            lblTitle.text = "-- 보험"
            lblSubTitle.text = "0000-00-00\n~ 0000-00-00"
        case .empty:
            lblSubTitle.isHidden = true
            lblTitle.textColor = .secondaryLabel
            lblTitle.text = strEmpty
            lblSubTitle.text = ""
        default:
            lblSubTitle.isHidden = false
            lblTitle.textColor = .label
            lblSubTitle.textColor = .label
            lblTitle.text = "\(insurance.corpName)"
            lblSubTitle.text = "\(Funcs.formatteredDate(date: insurance.dateStart))\n~ \(Funcs.formatteredDate(date: insurance.dateEnd))"
        }
    }
    
    func settingCellMileage(type: InsuranceStatue, insurance: Insurance! = nil) {
        lblTitle.text = "(등록 시 주행거리)"
        lblTitle.textColor = .secondaryLabel
        lblSubTitle.textColor = .secondaryLabel
        switch type {
        case .isNil, .empty:
            lblSubTitle.text = "-- km"
        default:
            lblSubTitle.text = "\(insurance.startMileage) km"
        }
    }
    
    func settingCellPay(type: InsuranceStatue, insurance: Insurance! = nil) {
        lblTitle.text = "(결제금)"
        lblTitle.textColor = .secondaryLabel
        lblSubTitle.textColor = .secondaryLabel
        switch type {
        case .isNil, .empty:
            lblSubTitle.text = "-- 원"
        default:
            lblSubTitle.text = "\(insurance.payContract) 원"
        }
    }
    func settingCellCall(type: InsuranceStatue, insurance: Insurance! = nil) {
        btnTelEdit.setImage(UIImage(systemName: "pencil"), for: .normal)
        switch type {
        case .isNil, .empty:
            btnTelNum.setTitle("0000-0000", for: .normal)
            btnTelNum.tintColor = .secondaryLabel
            btnTelEdit.tintColor = .secondaryLabel
        default:
            btnTelNum.setTitle(insurance.callOfCorp, for: .normal)
            btnTelNum.tintColor = .btnTealBackground
            btnTelEdit.tintColor = .btnTealBackground
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
    
    @IBAction func tabBtnTelNum(_ sender: Any) {
    }
    
    
    @IBAction func tabBtnTelEdit(_ sender: Any) {
    }
    
}
