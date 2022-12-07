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
    

    func settingLabel(text: String) {
        self.lblText.text = text
        lblText.textAlignment = .center
        lblText.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func settingImageView(image: String) {
        self.imgView.image = UIImage(systemName: image)
        imgView.contentMode = .scaleToFill
        imgView.tintColor = .systemTeal.withAlphaComponent(0.4)
        imgView.snp.makeConstraints {
            $0.height.equalToSuperview().offset(10)
            $0.center.equalToSuperview()
        }
        imgView.frame.size.width = imgView.frame.width / 2
    }
    
}
