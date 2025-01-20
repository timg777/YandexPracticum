//
//  HistoryLog.swift
//  YPCounter
//
//  Created by Superior Warden on 12.01.2025.
//

import UIKit


enum CounterOption {
    case belowZero
    case clear
    case subtract
    case add
    
    var logText: String {
        switch self {
        case .belowZero:
            return "[\(getCurrentDateTime)]: попытка уменьшить значение счетчика ниже 0"
        case .clear:
            return "[\(getCurrentDateTime)]: значение сброшено"
        case .subtract:
            return "[\(getCurrentDateTime)]: значенние изменено на -1"
        case .add:
            return "[\(getCurrentDateTime)]: значение изменено на +1"
        }
    }
    
    private var getCurrentDateTime: String {
        Date().formatted(date: .numeric, time: .standard)
    }
}
