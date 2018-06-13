//
//  Calculation.swift
//  TripletCalculator
//
//  Created by Sunny Shin on 2018. 1. 15..
//  Copyright © 2018 Seokyoung Avenue. All rights reserved.
//

import Foundation


class Calculation {

    var c = Context()
    
    func reset() {
        c.leftValue = ""
        c.currentValue = "0"
        c.wholeNumCount = 1
        c.decimalNumCount = 0
        c.firstOperator = .none
        c.currentStage = .lValue
    }

    func processNumber(number: Int) -> String? {
        if c.wholeNumCount == 12 && c.decimalNumCount == 4 {
            return nil
        } else if c.decimalNumCount == 4 {
            return nil
        } else if c.wholeNumCount == 12 && c.decimalNumCount == 0 {
            return nil
        }
        
        if c.decimalNumCount == 0 {
            if c.currentValue == "0" && number == 0 { // 0
                return nil
            } else if c.currentValue == "0" && number > 0 { // first number
                c.currentValue = String(number)
                return c.currentValue
            } else {
                c.currentValue += String(number)
                c.currentValue = removeComma(c.currentValue)
                c.currentValue = addComma(c.currentValue)
                c.wholeNumCount += 1
                return c.currentValue
            }
        } else {
            c.currentValue += String(number)
            c.decimalNumCount += 1
            return c.currentValue
        }
    }
    
    func processDecimalPoint() -> String? {
        if c.decimalNumCount != 0 || c.wholeNumCount == 0 {
            return nil
        }
        c.currentValue += "."
        c.decimalNumCount = 1
        return c.currentValue
    }
    
    func setCurrentValue(stringValue: String) {
        c.currentValue = stringValue
        (c.wholeNumCount, c.decimalNumCount) = getWholeDecimalCounts(stringValue: c.currentValue)
    }

    func setCurrentValue(doubleValue: Double) {
        c.currentValue = trimValue(doubleValue: doubleValue)
        c.currentValue = addComma(c.currentValue)
        (c.wholeNumCount, c.decimalNumCount) = getWholeDecimalCounts(stringValue: c.currentValue)
    }

    func processEqual() -> String? {
        if c.leftValue == "" || c.firstOperator == .none || c.currentValue == "" {
            return nil
        }
        
        let total = doCalc(leftValue: Double(removeComma(c.leftValue))!,
                           myOperator: c.firstOperator,
                           rightValue: Double(removeComma(c.currentValue))!)

        c.queue.write(c.currentValue) // rvalue
        setCurrentValue(doubleValue: total)
        c.queue.write(c.currentValue) // total
        c.firstOperator = .none
        c.currentStage = .lValue
        
        return c.currentValue
    }
    
    func processArithmeticOperators(_ op: Operator) -> String? {
        switch c.currentStage {
        case .lValue:
            c.leftValue = c.currentValue
            c.queue.write(c.currentValue) // lvalue
            c.currentValue = ""
            c.wholeNumCount = 0
            c.decimalNumCount = 0
            c.firstOperator = op
            c.currentStage = .rValue
            return nil
        case .rValue:
            if c.currentValue == "" {
                // operator 변경
                c.firstOperator = op
                return nil
            }
            
            let result = processEqual()
            
            c.leftValue = c.currentValue
            c.currentValue = ""
            c.wholeNumCount = 0
            c.decimalNumCount = 0
            c.firstOperator = op
            c.currentStage = .rValue
            return result
        default:
            assert(false)
        }
        return nil
    }
    
    func doCalc(leftValue: Double, myOperator: Operator, rightValue: Double) -> Double {
        var total: Double = 0
        switch myOperator {
        case .add:
            total = leftValue + rightValue
        case .subtract:
            total = leftValue - rightValue
        case .multiply:
            total = leftValue * rightValue
        case .divide:
            if leftValue == 0 {
                total = 0
            } else {
                total = leftValue / rightValue
            }
        default:
            assert(false)
        }

        if total > MAX_VALUE_DOUBLE {
            return MAX_VALUE_DOUBLE
        } else if total < MIN_VALUE_DOUBLE {
            return MIN_VALUE_DOUBLE
        }
        
        return total
    }
    
    func processDelete() -> String? {
        if c.currentValue == "" {
            return nil
        } else if c.decimalNumCount > 0 {
            c.decimalNumCount -= 1
            removeLastCharacter(&c.currentValue)
            return c.currentValue
        } else if c.wholeNumCount == 1 {
            if c.currentValue == "0" {
                return nil
            } else {
                c.currentValue = "0"
                return c.currentValue
            }
        } else {
            c.wholeNumCount -= 1
            c.currentValue = removeComma(c.currentValue)
            removeLastCharacter(&c.currentValue)
            c.currentValue = addComma(c.currentValue)
            return c.currentValue
        }
    }

    func processPrev() -> String? {
        return c.queue.readPrev()
    }
    
    func processNext() -> String? {
        return c.queue.readNext()
    }
    
    func processPeekPrev() -> Bool {
        return c.queue.peekPrev()
    }
    
    func processPeekNext() -> Bool {
        return c.queue.peekNext()
    }
}


