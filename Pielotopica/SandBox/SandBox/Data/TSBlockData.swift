//
//  TSBlockData.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/23.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/// 8bitのBlock Dataを表します。
/// もっと多くの情報が必要な場合はNBBデータを使用してください。
public class TSBlockData {
    public var value:UInt8
    
    public init(value:UInt8 = 0) {
        self.value = value
    }
    
    public var flag0:Bool {
        get { return (value & 0b00000001 << 0) != 0 }
        set { if newValue { value = value | 0b00000001 << 0 } else { value = value & ~(0b00000001 << 0) } }
    }
    public var flag1:Bool {
        get { return (value & 0b00000001 << 1) != 0 }
        set { if newValue { value = value | 0b00000001 << 1 } else { value = value & ~(0b00000001 << 1) } }
    }
    public var flag2:Bool {
        get { return (value & 0b00000001 << 2) != 0 }
        set { if newValue { value = value | 0b00000001 << 2 } else { value = value & ~(0b00000001 << 2) } }
    }
    public var flag3:Bool {
        get { return (value & 0b00000001 << 3) != 0 }
        set { if newValue { value = value | 0b00000001 << 3 } else { value = value & ~(0b00000001 << 3) } }
    }
    public var flag4:Bool {
        get { return (value & 0b00000001 << 4) != 0 }
        set { if newValue { value = value | 0b00000001 << 4 } else { value = value & ~(0b00000001 << 4) } }
    }
    public var flag5:Bool {
        get { return (value & 0b00000001 << 5) != 0 }
        set { if newValue { value = value | 0b00000001 << 5 } else { value = value & ~(0b00000001 << 5) } }
    }
    public var flag6:Bool {
        get { return (value & 0b00000001 << 6) != 0 }
        set { if newValue { value = value | 0b00000001 << 6 } else { value = value & ~(0b00000001 << 6) } }
    }
    public var flag7:Bool {
        get { return (value & 0b00000001 << 7) != 0 }
        set { if newValue { value = value | 0b00000001 << 7 } else { value = value & ~(0b00000001 << 7) } }
    }
}
