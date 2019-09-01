//
//  GKRealTimeTimer.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

///　もしアプリ終了中に呼ばれていたら、値の更新を行いコールバックは1度呼ばれる
class GKRealTimeValueTimer<T>: GKRealTimeTimer {
    
    var value:T
    private var _initirized = false
    private var _map: (T) -> T
    
    init(_ name: String, interval: TimeInterval, initial:T , map:@escaping (T) -> T, callback: @escaping (GKRealTimeValueTimer) -> Void) {
        self._map = map
        self.value = initial
        
        super.init(name, interval: interval, callback: {timer in
            callback(timer as! GKRealTimeValueTimer)
        })
        
        callback(self)
        _initirized = true
    }
    
    override func _callback() {
        value = _map(value)
        
        if _initirized {
            super._callback()
        }
    }
}

/// もしアプリ終了中に呼ばれていたら、複数回コールバックが呼ばれる。
class GKRealTimeTimer {
    // =============================================================== //
    // MARK: - Properties -
    
    private let name:String
    private let callback: (GKRealTimeTimer)->Void
    private let startTimeStamp: Date
    private let interval: TimeInterval
    
    private var lastUpdateTimeStamp: Date
    private var timer:Timer?
    
    // =============================================================== //
    // MARK: - Methods -
    
    func stop() {
        timer = nil
        RMStorage.shared.remove(with: _GKRealTimeTimerData.key(for: name))
    }
    func resume() {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: {[weak self] timer in
            guard let self = self else {return timer.invalidate()}
            
            self._update()
        })
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    init(_ name:String, interval: TimeInterval, callback: @escaping (GKRealTimeTimer)->Void ) {
        
        self.callback = callback
        self.interval = interval
        
        if let stored = RMStorage.shared.get(for: _GKRealTimeTimerData.key(for: name)) {
            self.name = stored.name
            self.startTimeStamp = stored.startTimeStamp
            self.lastUpdateTimeStamp = stored.lastUpdateTimeStamp
            
            let remain = (Date().timeIntervalSince1970 - self.lastUpdateTimeStamp.timeIntervalSince1970) / interval
            
            for _ in 0..<Int(remain) {
                _callback()
            }
        }else{
            self.name = name
            self.startTimeStamp = Date()
            self.lastUpdateTimeStamp = Date()
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: {[weak self] timer in
            guard let self = self else {return timer.invalidate()}
            
            self._update()
        })

    }
    
    // =============================================================== //
    // MARK: - Private -
    private func _createData() -> _GKRealTimeTimerData {
        _GKRealTimeTimerData(name: name, startTimeStamp: startTimeStamp, lastUpdateTimeStamp: lastUpdateTimeStamp)
    }
    fileprivate func _callback() {
        callback(self)
    }
    fileprivate func _update() {
        _callback()
        
        self.lastUpdateTimeStamp = Date()
        RMStorage.shared.store(_createData(), for: _GKRealTimeTimerData.key(for: name))
    }
}


private struct _GKRealTimeTimerData: RMStorable {
    
    static func key(for name:String) -> RMStorage.Key<_GKRealTimeTimerData> {
        .init(rawValue: "_GKRealTimeTimerData__" + name)
    }
    let name:String
    let startTimeStamp: Date
    let lastUpdateTimeStamp: Date
    
}
