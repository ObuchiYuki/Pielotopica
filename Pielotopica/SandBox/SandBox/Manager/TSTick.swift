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
    private var stack = [Int: [(TSTick)->()]]()
    
    // ================================================================== //
    // MARK: - Properties -
    public var value: UInt = 0 {
        didSet { self._tickDidUpdated(to: value) }
    }
    
    // ================================================================== //
    // MARK: - Methods -
    public func next(_ times:Int = 0, _ block: @escaping ()->()) {
        self.next(times, {_ in block() })
    }
    
    public func next(_ times:Int = 0, _ block: @escaping (TSTick)->()) {
        if self.stack[times] == nil {self.stack[times] = []}
        self.stack[times]?.append(block)
    }
    
    public func update() {
        value += 1
    }
    
    // ================================================================== //
    // MARK: - Privates -
    private func _tickDidUpdated(to value: UInt) {
        for run in stack[0] ?? [] {
            run(self)
        }
        
        stack.removeValue(forKey: 0)
        
        var _stack = [Int: [(TSTick)->()]]()
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
