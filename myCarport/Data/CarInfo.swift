//
//  CarInfo.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/02.
//

import UIKit

struct CarInfo {
    let id: UUID = UUID()
    var carName: String
    var carNumber: String
    var typeFuel: TypeFuel
    var typeShift: TypeShift
    var mileage: Int = 0
    var insurance: [Insurance]!
    var maintenance: [Maintenance]!
    
    enum TypeFuel {
        case gasoline
        case diesel
    }

    enum TypeShift {
        case Auto
        case Stick
    }
}

