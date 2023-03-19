//
//  Protocols.swift
//  myCarport
//
//  Created by yeonhoc5 on 2023/03/07.
//

import Foundation

protocol ChangeAnimationCount {
    func addAnimationCount(count: Int)
    func removeAnimationCount(at: Int)
}

protocol AddHistory {
    func addHistory(_ history: ManageHistory) 
}

