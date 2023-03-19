//
//  EnumList.swift
//  myCarport
//
//  Created by yeonhoc5 on 2023/03/01.
//

import Foundation

public enum TypeFuel: Int16 {
    case gasoline = 0
    case diesel = 1
    case hybrid = 2
    case electric = 3
    case none = 99
}

public enum TypeShift: Int16 {
    case auto = 0
    case manual = 1
    case none = 99
}

extension Int16 {
    func toTypeFuel() -> TypeFuel {
        switch self {
        case 0: return .gasoline
        case 1: return .diesel
        case 2: return .hybrid
        case 3: return .electric
        default: return .none
        }
    }
    func toTypeFuelString() -> String {
        switch self {
        case 0: return "휘발유"
        case 1: return "경유"
        case 2: return "하이브리드"
        case 3: return "전기"
        default: return "미분류"
        }
    }
    
    func toTypeShift() -> TypeShift {
        switch self {
        case 0: return .auto
        case 1: return .manual
        default: return .none
        }
    }
    func toTypeShiftString() -> String {
        switch self {
        case 0: return "오토"
        case 1: return "스틱"
        default: return "미분류"
        }
    }
}

enum AnimationRange {
    case all, one, none
}

enum EditType {
    case add, modify
}
