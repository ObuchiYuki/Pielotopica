//
//  RMLock.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class RMLock {
    // ================================================================ //
    // MARK: - Properties -
    private var _isLocked: Bool
    private var _method: (()->())?
    
    public var isLocked:Bool {
        return _isLocked
    }
    // ================================================================ //
    // MARK: - Methods -
    
    public func call() {
        _isLocked = true
        _method()
        _isLocked = false
    }
    
    // ================================================================ //
    // MARK: - Constructor -
    public init(_ first:Bool = false, method: @escaping ()->()) {
        self._isLocked = first
        self._method = method
    }
}
