//
//  TSBlockRotation.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/23.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/// flag0, flag1の2bit使います。
public enum TSBlockRotation {
    case x0 // (0, 0)
    case x1 // (0, 1)
    case x2 // (1, 0)
    case x3 // (1, 1)
    
    var rotation:Int {
        switch self {
        case .x0: return 0
        case .x1: return 1
        case .x2: return 2
        case .x3: return 3
        }
    }
    var nodeModifier:TSVector3 {
        switch self {
        case .x0: return .zero
        case .x1: return TSVector3( 0,  0,  1)
        case .x2: return TSVector3( 1,  0,  1)
        case .x3: return TSVector3( 1,  0,  0)
        }
    }
    var eulerAngle:Double {
        return Double.pi / 2 * Double(rotation)
    }
    
    public init(rotation ry:Int) {
        switch ry % 4 {
        case 0: self = .x0
        case 1: self = .x1
        case 2: self = .x2
        case 3: self = .x3
        default: fatalError()
        }
    }
    public init(data: TSBlockData) {
        switch (data.flag0, data.flag1) {
        case (false, false): self = .x0
        case (false, true ): self = .x1
        case (true , false): self = .x2
        case (true , true ): self = .x3
        }
    }
    
    public func setData(to data:inout TSBlockData) { //本来Classにinoutは必要ないが、識別のため
        switch self {
        case .x0:  data.flag0 = false; data.flag1 = false
        case .x1:  data.flag0 = false; data.flag1 = true
        case .x2:  data.flag0 = true ; data.flag1 = false
        case .x3:  data.flag0 = true ; data.flag1 = true
        }
    }
}
