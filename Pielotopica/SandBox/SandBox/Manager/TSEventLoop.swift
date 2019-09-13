//
//  TSEventLoop.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// MARK: - TSEventLoop -

public class TSEventLoop {
    
    // MARK: - Singleton -
    public static let shared = TSEventLoop()
    
    // MARK: - Proeprties -
    private var _timer:Timer!
    
    // MARK: - Methods -
    public func start() {
        self._timer = _createTimer()
    }
    
    public func stop() {
        self._timer.invalidate()
        self._timer = nil
    }
    
    private func _createTimer() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: TSTick.unit, repeats: true, block: {[unowned self] timer in
            self._update()
        })
    }
    
    // MARK: - Privates -
    private func _update() {
        
    }
}
