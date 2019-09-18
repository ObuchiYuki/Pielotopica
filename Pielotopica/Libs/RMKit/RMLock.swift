//
//  RMLock.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class RMLock {
    private var _isLocked: Bool
    
    public var isLocked:Bool {
        return _isLocked
    }
    
    public func lock() {
        _isLocked = true
    }
    public func unlock() {
        _isLocked = false
    }
    
    public init(_ first:Bool = false) {
        self._isLocked = first
    }
}
