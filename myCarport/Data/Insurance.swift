//
//  Insurance.swift
//  myCarport
//
//  Created by yeonhoc5 on 2022/11/16.
//

import Foundation

enum InsuranceCorp: String {
    case ssHaejae
    case hdHaesang
}

struct Insurance {
    var corpName: InsuranceCorp
    var dateStart: Data
    var dataEnd: Date
    var payContract: Int
    var callOfCorp: String
}
