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
        formatter.dateFormat = "yy/MM/dd"
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter.string(from: date)
    }
    
//    static func formatteredNumber(num: Int) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        return formatter.string(from: num)
//    }

 
    static func checkValidation(textFields: [UITextField], btn: UIButton, type: EmptyCheckType! = .all) {
        var checkNum = type == .all ? 1 : 0
        if type == .all {
            textFields.forEach {
                checkNum *= $0.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            }
        } else {
            textFields.forEach {
                checkNum += $0.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            }
        }
        btn.isEnabled = checkNum == 0 ? false : true
    }
    
    
    static func numberToString(number: Int) -> String {
        var string = String(number).replacingOccurrences(of: "00000", with: "0만")
        string = string.replacingOccurrences(of: "0000", with: "만")
        string = string.replacingOccurrences(of: "000", with: "천")
        string = string.replacingOccurrences(of: "00", with: "백")
        return string
    }

    static func addCommaToNumber(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: number))
        return formattedNumber ?? "0"
    }
    
}




enum EmptyCheckType {
    case all, any
}

extension StringProtocol  {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}
