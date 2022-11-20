//
//  Maintenance.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/16.
//

import Foundation

struct Maintenance {
//    let filterAC: MaintenanceInfo
//
//    let oilEngine: MaintenanceInfo
//    let filterAir: MaintenanceInfo
//    let filterOil: MaintenanceInfo
//    let wiper: MaintenanceInfo
//
//    let sparkPlug: MaintenanceInfo
//    let filterFuel: MaintenanceInfo
//    let breakFluid: MaintenanceInfo
//
//    let breakPad: MaintenanceInfo
//    let oilMission: MaintenanceInfo
//    let coolingWater: MaintenanceInfo
//
//    let oilPowerSteering: MaintenanceInfo
//    let tireFront: MaintenanceInfo
//    let tireBack: MaintenanceInfo
//
//    let beltDrive: MaintenanceInfo
//    let beltTiming: MaintenanceInfo
//
//    let battery: MaintenanceInfo
//
//    let oilDifferential: MaintenanceInfo
//
//}

//struct MaintenanceInfo {
    var nameOfItem: String
    var cycleMileage: Int
    var cyclePeriod: Int!
    var historyManage: [ManageHistory]!
}
        
struct ManageHistory {
    var mileage: Int = 0
    var ChangeDate: Date!
}
