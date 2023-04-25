//
//  Protocols.swift
//  myCarport
//
//  Created by yeonhoc5 on 2023/03/07.
//

import Foundation
// 차량 추가/삭제 시 애니메이션 카운트 추가/삭제
protocol ChangeAnimationCount {
    func addAnimationCount(count: Int)
    func removeAnimationCount(at: Int)
}
//
protocol AddHistory {
    func addHistory(_ history: ManageHistory) 
}
// 차량 추가시 차량 목록 갱신
protocol RenewCarList {
    func renewCarList()
}
