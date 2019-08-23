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
class TSBlockData {
    var value:UInt8
    
    init(value:UInt8) {
        self.value = value
    }
    
    var flag0:Bool {
        get { return (value & 0b00000001 << 0) != 0 }
        set { if newValue { value = value | 0b00000001 << 0 }else{ value = value & ~(0b00000001 << 0) } }
    }
    var flag1:Bool {
        get { return (value & 0b00000001 << 1) != 0 }
        set { if newValue { value = value | 0b00000001 << 1 }else{ value = value & ~(0b00000001 << 1) } }
    }
    var flag2:Bool {
        get { return (value & 0b00000001 << 2) != 0 }
        set { if newValue { value = value | 0b00000001 << 2 }else{ value = value & ~(0b00000001 << 2) } }
    }
    var flag3:Bool {
        get { return (value & 0b00000001 << 3) != 0 }
        set { if newValue { value = value | 0b00000001 << 3 }else{ value = value & ~(0b00000001 << 3) } }
    }
    var flag4:Bool {
        get { return (value & 0b00000001 << 4) != 0 }
        set { if newValue { value = value | 0b00000001 << 4 }else{ value = value & ~(0b00000001 << 4) } }
    }
    var flag5:Bool {
        get { return (value & 0b00000001 << 5) != 0 }
        set { if newValue { value = value | 0b00000001 << 5 }else{ value = value & ~(0b00000001 << 5) } }
    }
    var flag6:Bool {
        get { return (value & 0b00000001 << 6) != 0 }
        set { if newValue { value = value | 0b00000001 << 6 }else{ value = value & ~(0b00000001 << 6) } }
    }
    var flag7:Bool {
        get { return (value & 0b00000001 << 7) != 0 }
        set { if newValue { value = value | 0b00000001 << 7 }else{ value = value & ~(0b00000001 << 7) } }
    }
}
