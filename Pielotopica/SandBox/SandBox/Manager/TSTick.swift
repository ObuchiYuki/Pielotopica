//
//  TSTick.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSTick {
    public static let shared = TSTick()
    
    public var value: UInt = 0
    
    private init() {}
}
extension TSTick {
    public static let unit = 0.05
}
