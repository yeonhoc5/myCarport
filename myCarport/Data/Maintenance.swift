//
//  Maintenance.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/16.
//

import Foundation

struct Maintenance: Identifiable, Equatable {
    static func == (lhs: Maintenance, rhs: Maintenance) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: Int
    var nameOfItem: String
    var cycleMileage: Int
    var cyclePeriod: Int!
    var historyManage: [ManageHistory]
}
        
struct ManageHistory {
    var mileage: Int = 0
    var ChangeDate: Date!
}
