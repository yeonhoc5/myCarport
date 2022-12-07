//
//  Insurance.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/16.
//

import Foundation

//enum InsuranceCorp: String {
//    case ssHaejae = "삼성화재"
//    case hdHaesang = "현대해상"
//}

struct Insurance {
    var corpName: String
    var dateStart: Date
    var dateEnd: Date
    var payContract: Int = 0
    var startMileage: Int = 0
    var callOfCorp: String!
}
