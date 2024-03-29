//
//  HomeCollectionViewCell.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/02.
//

import UIKit
import SnapKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    lazy var lblCarName: UILabel! = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    func settingCell(name: String, background: UIColor) {
        addSubview(lblCarName)
        lblCarName.text = name
        lblCarName.sizeToFit()
        lblCarName.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        self.backgroundColor = background
        self.layer.cornerRadius = 10
    }
    
}
