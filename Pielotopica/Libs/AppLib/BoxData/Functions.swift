//
//  Functions.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/15.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public func OptimazedRange(_ value1:Int16,_  value2: Int16 = 0) -> Range<Int16> {
    if value1 > value2 {
        return Range(uncheckedBounds: (lower: value2   , upper: value1))
    }else{
        return Range(uncheckedBounds: (lower: value1+1 , upper: value2))
    }
}
