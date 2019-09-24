//
//  RMMeasure.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class RMMeasure {
    private let _start: Date
    
    public init() {
        self._start = Date()
    }
    
    public func end(_ message: String = "") {
        let interval = Date().timeIntervalSince(_start)
        
        print(message, interval, "s")
    }    
}
