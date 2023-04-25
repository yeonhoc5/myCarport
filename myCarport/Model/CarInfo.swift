//
//  CarInfo.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/02.
//

import UIKit
import CoreData

struct CarInfo: Equatable {
    static func == (lhs: CarInfo, rhs: CarInfo) -> Bool {
        return lhs.objectID == rhs.objectID
    }
    
    var orderID: Int = Int()
    var carName = String()
    var carNumber = String()
    var typeFuel = TypeFuel.gasoline
    var typeShift = TypeShift.auto
    var mileage: Int = 0
    var insurance: [Insurance] = []
    var maintenance: [Maintenance] = []
    
    // 원본 CarInfoMO 객체를 참조하기 위한 속성
    var objectID: NSManagedObjectID?
}

