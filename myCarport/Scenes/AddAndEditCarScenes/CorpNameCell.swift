//
//  CorpNameCell.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/12/04.
//

import UIKit

class CorpNameCell: UICollectionViewCell {
    
    @IBOutlet var lblNameOfCorp: UILabel!
    @IBOutlet var imgViewOfCorp: UIImageView!
    
    func settingCell(image: String) {
        self.backgroundColor = .white
        imgViewOfCorp.image = UIImage(named: image)
        imgViewOfCorp.contentMode = .scaleAspectFit
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        self.layer.borderWidth = 0.4
    }
    
}
