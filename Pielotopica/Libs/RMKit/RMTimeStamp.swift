//
//  RMTimeStamp.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/21.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/// Delta Timeを測るのに適しています。
public class RMTimeStamp {
    // ============================================================ //
    // MARK: - Properties -
    
    private var _timeStamp:TimeInterval = 0
    
    // ============================================================ //
    // MARK: - Methods -
    
    public func press() {
        _timeStamp = Date().timeIntervalSince1970
    }
    public func isSameFrame() -> Bool {
        return delta() < 0.1
    }
    
    public func delta() -> TimeInterval {
        return abs(_timeStamp - Date().timeIntervalSince1970)
    }
}
