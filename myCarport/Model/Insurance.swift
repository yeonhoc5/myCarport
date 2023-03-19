//
//  Insurance.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/16.
//

import Foundation
import CoreData

struct Insurance {
    var corpName: String?
    var dateStart: Date?
    var dateEnd: Date?
    var payContract: Int = 0
    var mileageContract: Int = 0
    var callOfCorp: Int?
    
    var objectID: NSManagedObjectID?
}


