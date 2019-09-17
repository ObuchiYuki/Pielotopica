//
//  TSTick.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// ================================================================== //
// MARK: - TSTick -
public class TSTick {
    // ================================================================== //
    // MARK: - Privates -
    private var stack = [Int: [String: ()->()]]()
    
    // ================================================================== //
    // MARK: - Properties -
    public let asyncQueue = DispatchQueue(label: "com.topica.TSTick")
    
    public var value: UInt = 0 {
        didSet { self._tickDidUpdated(to: value) }
    }
    
    // ================================================================== //
    // MARK: - Methods -
    
    public func async(_ times:Int = 0, identifier: String = "" , _ block: @escaping ()->()) {
        self.next(times, identifier: identifier, {
            self.asyncQueue.async {
                block()
            }
        })
    }
    public func next(_ times:Int = 0, identifier: String = "default" , _ block: @escaping ()->()) {
        if self.stack[times] == nil {self.stack[times] = [:]}
            
        self.stack[times]![identifier] = block
    }
    
    public func update() {
        value += 1
    }
    
    // ================================================================== //
    // MARK: - Privates -
    private func _tickDidUpdated(to value: UInt) {
        if stack[0] != nil {
            while !stack[0]!.isEmpty {
                for (key, value) in stack[0]! {
                    value()
                    stack[0]!.removeValue(forKey: key)
                }
            }
        }
        
        stack.removeValue(forKey: 0)
        
        var _stack = [Int: [String: ()->()]]()
        
        for (key, value) in stack {
            _stack[key - 1] = value
        }
        
        self.stack = _stack
    }
    
    private init() {}
}

extension TSTick {
    public static let shared = TSTick()
    
    public static let unit = 0.05
}
