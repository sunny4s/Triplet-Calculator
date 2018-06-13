//
//  Utils.swift
//  TripletCalculator
//
//  Created by Sunny Shin on 2018. 1. 15.
//  Copyright © 2018 Seokyoung Avenue. All rights reserved.
//

import Foundation


func addComma(_ strValue: String) -> String {
    var value = strValue
    var result: String = ""
    
    if value.index(of: "-") != nil {
        removeFirstCharacter(&value)
        result = "-"
    }
    
    let idxPoint = value.index(of: ".") ?? value.endIndex
    let wholeNum = value[..<idxPoint]
    let decimal = value[idxPoint...]
    var index = wholeNum.count - 1
    
    for character in wholeNum {
        result += String(character)
        if index >= 3 && index % 3 == 0 {
            result += ","
        }
        index -= 1
    }
    
    return result + decimal
}

func removeComma(_ strValue: String) -> String {
    var result = ""
    for character in strValue {
        if character != "," {
            result += String(character)
        }
    }
    return result
}

func trimValue(doubleValue: Double) -> String {
    if doubleValue == Double(Int(doubleValue)) { // Int
        return String(Int(doubleValue))
    }
    
    let strValue = String(doubleValue)
    let idxPoint = strValue.index(of: ".") ?? strValue.endIndex
    let decimal = strValue[idxPoint...]
    if decimal.count == 0 {
        return String(Int(doubleValue))
    } else if (decimal.count <= 4) {
        return String(doubleValue)
    } else {
        return String(Int(doubleValue)) + decimal.prefix(4)
    }
}

func getWholeDecimalCounts(doubleValue: Double) -> (wholeNumCnt: Int, decNumCnt: Int) {
    let stringValue = String(doubleValue)
    let idx = stringValue.index(of: ".") ?? stringValue.endIndex
    let wholeNumCnt = stringValue[..<idx].count
    var decNumCnt = 0
    if doubleValue != Double(Int(doubleValue)) {
        decNumCnt = stringValue[idx...].count
    }
    return (wholeNumCnt, decNumCnt)
}

func getWholeDecimalCounts(stringValue: String) -> (wholeNumCnt: Int, decNumCnt: Int) {
    let idx = stringValue.index(of: ".") ?? stringValue.endIndex
    let wholeNumCnt = stringValue[..<idx].count
    let decNumCnt = stringValue[idx...].count
    return (wholeNumCnt, decNumCnt)
}

func removeLastCharacter(_ str: inout String) {
    str.remove(at: str.index(before: str.endIndex))
}

func removeFirstCharacter(_ str: inout String) {
    str.remove(at: str.startIndex)
}


