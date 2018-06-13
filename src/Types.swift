//
//  Types.swift
//  TripletCalculator
//
//  Created by Sunny Shin on 2018. 1. 15.
//  Copyright © 2018 Seokyoung Avenue. All rights reserved.
//

import Foundation


let MAX_VALUE_DOUBLE = 999999999999.999
let MIN_VALUE_DOUBLE = -99999999999.999

let HISTORY_QUEUE_SIZE: Int = 100

enum Operator: Int {
    case none
    case add, subtract, multiply, divide
    case equal, point
    case undo, redo
    case clear, magic
    case sendLeft, sendRight
    
    func isArithmetic() -> Bool {
        switch self {
        case .add, .subtract, .multiply, .divide:
            return true
        default:
            return false
        }
    }
    
    func desc() -> String {
        switch self {
        case .add: return "+"
        case .subtract: return "-"
        case .multiply: return "x"
        case .divide: return "/"
        case .equal: return "="
        default: return "?"
        }
    }
}

enum Stage: Int {
    case none
    case lValue
    case rValue
}

let PAGE_NUM = 3
let CONTEXT_NUM = PAGE_NUM
let INITIAL_TOTAL_VALUE = "0"

public struct Context {
    var _page = 0
    var currentPage: Int? {
        get {
            return self._page
        }
        set {
            self._page = newValue!
        }
    }
    
    var leftValue: String {
        get {
            return self._leftValue[self._page]
        }
        set {
            self._leftValue[self._page] = newValue
        }
    }
    var currentValue: String {
        get {
            return self._currentValue[self._page]
        }
        set {
            self._currentValue[self._page] = newValue
        }
    }
    var wholeNumCount: Int {
        get {
            return self._wholeNumCount[self._page]
        }
        set {
            self._wholeNumCount[self._page] = newValue
        }
    }
    var decimalNumCount: Int {
        get {
            return self._decimalNumCount[self._page]
        }
        set {
            self._decimalNumCount[self._page] = newValue
        }
    }
    var firstOperator: Operator {
        get {
            return self._firstOperator[self._page]
        }
        set {
            self._firstOperator[self._page] = newValue
        }
    }
    var currentStage: Stage {
        get {
            return self._currentStage[self._page]
        }
        set {
            self._currentStage[self._page] = newValue
        }
    }
    var queue: CircularQueue<String> {
        get {
            return self._queue[0]
        }
        set {
            self._queue[0] = newValue
        }
    }
    
    var _leftValue: Array<String> = Array(repeating: "", count: CONTEXT_NUM)
    var _currentValue: [String] = Array(repeating: INITIAL_TOTAL_VALUE, count: CONTEXT_NUM)
    var _wholeNumCount: [Int] = Array(repeating: INITIAL_TOTAL_VALUE.count, count: CONTEXT_NUM)
    var _decimalNumCount: [Int] = Array(repeating: 0, count: CONTEXT_NUM)
    var _firstOperator: [Operator] = Array(repeating: .none, count: CONTEXT_NUM)
    var _currentStage: [Stage] = Array(repeating: .lValue, count: CONTEXT_NUM)
    var _queue: [CircularQueue<String>] = []
    
    init() {
        for _ in 0...CONTEXT_NUM-1 {
            let q = CircularQueue<String>(count: HISTORY_QUEUE_SIZE)
            self._queue.append(q)
        }
    }
}


