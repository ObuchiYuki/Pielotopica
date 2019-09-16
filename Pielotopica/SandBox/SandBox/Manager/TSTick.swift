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
    private var stack = [(TSTick)->()]()
    
    // ================================================================== //
    // MARK: - Properties -
    public var value: UInt = 0 {
        didSet { self._tickDidUpdated(to: value) }
    }
    
    // ================================================================== //
    // MARK: - Methods -
    public func next(_ block: @escaping ()->()) {
        self.stack.append({_ in block()})
    }
    
    public func next(_ block: @escaping (TSTick)->()) {
        self.stack.append(block)
        
    }
    public func update() {
        value += 1
    }
    
    // ================================================================== //
    // MARK: - Privates -
    private func _tickDidUpdated(to value: UInt) {
        for run in stack {
            run(self)
        }
        
        stack = []
    }
    
    private init() {}
}

extension TSTick {
    public static let shared = TSTick()
    
    public static let unit = 0.05
}
