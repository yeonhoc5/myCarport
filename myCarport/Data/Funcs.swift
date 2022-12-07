//
//  Funcs.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/12/01.
//

import Foundation
import UIKit

struct Funcs {
    static func formatteredDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter.string(from: date)
    }
    
//    static func formatteredNumber(num: Int) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        return formatter.string(from: num)
//    }

 
    static func checkValidation(textFields: [UITextField], btn: UIButton) {
        var checkNum = 1
        textFields.forEach {
            checkNum *= $0.text?.count ?? 0
        }
        
        btn.isEnabled = checkNum == 0 ? false:true
    }
    
}
