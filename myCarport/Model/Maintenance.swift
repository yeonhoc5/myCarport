//
//  Maintenance.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/16.
//

import Foundation
import CoreData

struct Maintenance {

    var nameOfItem = String()
    var cycleMileage = Int()
    var cyclePeriod: Int?
    var historyManage: [ManageHistory] = []
    
    var objectID: NSManagedObjectID?
    
}
        
struct ManageHistory {
    var mileage: Int = 0
    var changeDate = Date()
    
    var objectID: NSManagedObjectID?
}
