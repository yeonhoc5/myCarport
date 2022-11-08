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
    var currentMileage: Int = 0
    var lastChangeDate: Date?
}

let carListSample: [CarInfo] = [
    CarInfo(carName: "라세티", carNumber: "48소9953", typeFuel: .gasoline, typeShift: .Auto, mileage: 128999, insurance: .ssHwajae, maintenance: Maintenance(oilEngine: MaintenanceInfo(), oilMission: MaintenanceInfo(), fltAirConditioner: MaintenanceInfo(), fltOil: MaintenanceInfo())),
    CarInfo(carName: "트레일블레이저", carNumber: "000가0000", typeFuel: .diesel, typeShift: .Stick, mileage: 0, insurance: .hhSangmyeong, maintenance: Maintenance(oilEngine: MaintenanceInfo(), oilMission: MaintenanceInfo(), fltAirConditioner: MaintenanceInfo(), fltOil: MaintenanceInfo()))
]
