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

extension BehaviorRelay:Codable where Element: Codable {
    enum ChildKeys: CodingKey {
        case value
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ChildKeys.self)
        let value = try container.decode(Element.self, forKey: .value)
        
        self.init(value: value)
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ChildKeys.self)
        try container.encode(self.value, forKey: .value)

    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func append(_ newElement:Element.Element) {
        self.accept(value + [newElement])
    }
}
