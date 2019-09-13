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
        self._timer = Timer.scheduledTimer(withTimeInterval: <#T##TimeInterval#>, repeats: <#T##Bool#>, block: <#T##(Timer) -> Void#>)
    }
    
    public func stop() {
        
    }
    
    public func resume() {
        
    }
}
