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
    case xPlus  // (0, 0)
    case xMinus // (0, 1)
    case zPlus  // (1, 0)
    case zMinus // (1, 1)
    
    public init(data: TSBlockData) {
        switch (data.flag0, data.flag1) {
        case (false, false): self = .xPlus
        case (false, true):  self = .xMinus
        case (true, false):  self = .zPlus
        case (true, true):   self = .zMinus
        }
    }
    
    
    public func setData(to data:inout TSBlockData) { //本来Classにinoutは必要ないが、識別のため
        switch self {
        case .xPlus:   data.flag0 = false; data.flag1 = false
        case .xMinus:  data.flag0 = false; data.flag1 = true
        case .zPlus:   data.flag0 = true ; data.flag1 = false
        case .zMinus:  data.flag0 = true ; data.flag1 = true
        }
    }
}
