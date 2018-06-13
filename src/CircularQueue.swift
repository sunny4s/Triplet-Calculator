//
//  CircularQueue.swift
//  TripletCalculator
//
//  Created by Sunny Shin on 2018. 1. 15..
//  Copyright © 2018 Seokyoung Avenue. All rights reserved.
//

import Foundation

public struct CircularQueue<T> {
    fileprivate var array: [T?]
    fileprivate var readIndex = -1
    fileprivate var writeIndex = 0
    fileprivate var count = 0
    
    public init(count: Int) {
        array = [T?](repeating: nil, count: count)
    }
    
    private mutating func incCount() {
        if count < array.count {
            count += 1
        }
    }
    
    private mutating func incWriteIndex() {
        writeIndex = (writeIndex + 1) % array.count
    }
    
    private mutating func incReadIndex() {
        readIndex = (readIndex + 1) % array.count
    }
    
    private mutating func decReadIndex() {
        if readIndex == 0 {
            readIndex = array.count - 1
        } else {
            readIndex -= 1
        }
    }
    
    private func decIndex(_ index: Int) -> Int {
        if index == 0 {
            return array.count - 1
        } else {
            return index - 1
        }
    }
    
    private mutating func resetReadIndex() {
        if writeIndex == 0 {
            readIndex = array.count - 1
        } else {
            readIndex = writeIndex - 1
        }
    }
    
    public mutating func write(_ element: T) {
        if element is String && String(describing: element) == "" {
            return
        }
        array[writeIndex] = element
        incCount()
        incWriteIndex()
        readIndex = -1
    }

    public mutating func peekPrev() -> Bool {
        if count == 0 {
            return false
        } else if readIndex < 0 {
            return true
        } else {
            decReadIndex()
            if readIndex == decIndex(writeIndex) {
                incReadIndex()
                return false
            }
        }

        if count < array.count && readIndex >= count {
            incReadIndex()
            return false
        }

        incReadIndex()
        return true
    }
    
    public mutating func readPrev() -> T? {
        if count == 0 {
            return nil
        } else if readIndex < 0 {
            resetReadIndex()
        } else {
            decReadIndex()
            if readIndex == decIndex(writeIndex) {
                incReadIndex()
                return nil
            }
        }
        
        if count < array.count && readIndex >= count {
            incReadIndex()
            return nil
        }
        
        return array[readIndex]
    }

    public mutating func peekNext() -> Bool {
        if count == 0 {
            return false
        } else if readIndex < 0 {
            return false
        } else {
            incReadIndex()
            if readIndex == writeIndex {
                decReadIndex()
                return false
            }
        }
        
        if count < array.count && readIndex >= count {
            decReadIndex()
            return false
        }
        
        decReadIndex()
        return true
    }

    public mutating func readNext() -> T? {
        if count == 0 {
            return nil
        } else if readIndex < 0 {
            resetReadIndex()
        } else {
            incReadIndex()
            if readIndex == writeIndex {
                decReadIndex()
                return nil
            }
        }
        
        if count < array.count && readIndex >= count {
            decReadIndex()
            return nil
        }
        
        return array[readIndex]
    }
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var isFull: Bool {
        return count == array.count
    }
}


