//
//  Ex+BehaviorRelay.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxSwift
import RxCocoa

// =============================================================== //
// - Ex + Operators -
extension BehaviorRelay where Element: Numeric {
    public static func += (left: BehaviorRelay, right:Element) {
        left.accept(left.value + right)
    }
    public static func -= (left: BehaviorRelay, right:Element) {
        left.accept(left.value - right)
    }
    public static func *= (left: BehaviorRelay, right:Element) {
        left.accept(left.value * right)
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func append(_ newElement:Element.Element) {
        self.accept(value + [newElement])
    }
}
