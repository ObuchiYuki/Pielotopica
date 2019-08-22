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
    private var _timerInitirized = false
    private var _timerCalled = false
    
    // ============================================================ //
    // MARK: - Methods -
    
    public func press() {
        _timerCalled = false
        _timeStamp = Date().timeIntervalSince1970
        
    }
    public func isSameFrame() -> Bool {
        return delta() < 0.1
    }
    
    public func monitorSequenceEnd(_ block: ((RMTimeStamp)->())?) {
        guard !_timerInitirized else {return}
        
        _timerInitirized = true
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {[weak self] timer in
            guard let self = self else {return timer.invalidate()}
            
            if !self._timerCalled && !self.isSameFrame() {
                self._timerCalled = true
                block?(self)
            }
        })
    }
    
    public func delta() -> TimeInterval {
        return abs(_timeStamp - Date().timeIntervalSince1970)
    }
}
