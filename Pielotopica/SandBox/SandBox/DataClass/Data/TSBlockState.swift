//
//  TSBlockState.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/23.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

/// 8bitのBlock Dataを表します。
/// もっと多くの情報が必要な場合はNBBデータを使用してください。
class TSBlockState {
    var value:UInt8
    
    init(value:UInt8) {
        self.value = value
    }
    
    var flag0:Bool {
        return (value & 0b00000001) != 0
    }
    var flag1:Bool {
        return (value & 0b00000010) != 0
    }
    var flag2:Bool {
        return (value & 0b00000100) != 0
    }
    var flag3:Bool {
        return (value & 0b00001000) != 0
    }
    var flag4:Bool {
        return (value & 0b00010000) != 0
    }
    var flag5:Bool {
        return (value & 0b00100000) != 0
    }
    var flag6:Bool {
        return (value & 0b01000000) != 0
    }
    var flag7:Bool {
        return (value & 0b10000001) != 0
    }
}
