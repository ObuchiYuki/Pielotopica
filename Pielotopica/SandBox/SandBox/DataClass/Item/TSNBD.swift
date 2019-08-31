//
//  TSNBD.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/// Name Based Data
/// よしなに保存して、よしなにデータを読み込みます。
public struct TSNBD: RMStorable {
    
    private let point:TSVector3
    private var stringData = [String: String]()
    private var intData = [String: Int]()
    private var doubleData = [String: Double]()

    mutating func set(_ data:String, for key:String) {
        RMStorage.shared.store(self, for: _key())
        
        stringData[key] = data
    }
    mutating func set(_ data:Int, for key:String) {
        RMStorage.shared.store(self, for: _key())
        
        intData[key] = data
    }
    mutating func set(_ data:Double, for key:String) {
        RMStorage.shared.store(self, for: _key())
        
        doubleData[key] = data
    }
    
    func string(for key:String) -> String? {
        stringData[key]
    }
    func int(for key:String) -> Int? {
        intData[key]
    }
    func float(for key:String) -> Double? {
        doubleData[key]
    }
    
    private func _key() -> RMStorage.Key<TSNBD> {
        RMStorage.Key<TSNBD>(rawValue: "TSNBD_u_\(point.x)_\(point.y)_\(point.z)")
    }
    init(point:TSVector3) {
        self.point = point
        
        if let saved = RMStorage.shared.get(for: _key()) {
            self.stringData = saved.stringData
            self.intData = saved.intData
            self.doubleData = saved.doubleData
        }
    }
}
