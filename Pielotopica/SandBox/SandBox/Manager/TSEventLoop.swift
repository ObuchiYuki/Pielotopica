//
//  TSEventLoop.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSEventLoop {
    public static let shared = TSEventLoop()
    
    private var _timer:Timer!
    
    public func start() {
        self.timer = _createTimer()
    }
    
    public func stop() {
        self.timer.in
    }
    
    public func resume() {
        
    }
    
    private func _createTimer() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: TSTick.unit, repeats: true, block: {[unowned self] timer in
            self._update()
        })
    }
    
    private func _update() {
        
    }
}
