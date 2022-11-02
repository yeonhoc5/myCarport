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
    var maileage: Int
    var insurance: Insurance
    var maintenance: Maintenance

    enum Insurance {
        case ssHwajae
        case hhSangmyeong
    }
    
    enum TypeFuel {
        case gasoline
        case diesel
    }

    enum TypeShift {
        case Auto
        case Stick
    }
}

struct Maintenance {
    let oilEngine: MaintenanceInfo
    let oilMission: MaintenanceInfo
    let fltAirConditioner: MaintenanceInfo
    let fltOil: MaintenanceInfo
}

struct MaintenanceInfo {
    var cycleMileage: Int?
    var cyclePeriod: Int?
    var currentMileage: Int?
    var lastChangeDate: Date?
}
