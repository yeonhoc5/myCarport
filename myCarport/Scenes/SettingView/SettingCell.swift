//
//  SettingCell.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit

class SettingCell: UITableViewCell {

    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblLoginGuide: UILabel!
    @IBOutlet var btnLogin: UIButton!
    
    @IBOutlet var lblCarName: UILabel!
    @IBOutlet var lblCarType: UILabel!
    
    @IBOutlet var btnSignOut: UIButton!
    @IBOutlet var btnLogOut: UIButton!
    
    @IBOutlet var stackBtnOut: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
