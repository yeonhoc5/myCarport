//
//  ItemDetailCell.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/09.
//

import UIKit
import SnapKit

class ItemDetailCell: UICollectionViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblText: UILabel!
    @IBOutlet var lblSubText: UILabel!
    
    func settingLabel(text: String) {
        self.lblText.text = text
        lblText.textAlignment = .center
        lblText.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func settingSubLabel(text: String, image: String) {
        imgView.image = UIImage(systemName: image)
        imgView.contentMode = .scaleToFill
        imgView.tintColor = .systemTeal.withAlphaComponent(0.4)
        
        lblSubText.text = text
        lblSubText.textAlignment = .right
        
        imgView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
            $0.width.equalTo(15)
        }
        lblSubText.snp.makeConstraints {
            $0.leading.equalTo(imgView.snp.trailing)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
}
