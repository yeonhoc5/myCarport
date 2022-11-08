//
//  TitleLabel.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/08.
//

import UIKit

extension UILabel {
    convenience init(x:Int = 0, y:Int = 0, width: Int, height: Int, text: String, aliignment: NSTextAlignment, fontSize: CGFloat = 17, fontWeight: UIFont.Weight = .semibold, fontColor: UIColor = UIColor.label, doFit: Bool = false) {
        self.init()
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        self.text = text
        self.textAlignment = aliignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.textColor = fontColor
        doFit ? self.sizeToFit():nil
        self.frame.size.height = CGFloat(height)
    }
}
