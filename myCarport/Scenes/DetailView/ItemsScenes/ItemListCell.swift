//
//  ItemListCell.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/12/05.
//

import UIKit
import SnapKit

class ItemListCell: UITableViewCell {

    
    @IBOutlet var lblItemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            let inset: CGFloat = 25
            var frame = newFrame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            super.frame = frame
        }
    }
    
}
