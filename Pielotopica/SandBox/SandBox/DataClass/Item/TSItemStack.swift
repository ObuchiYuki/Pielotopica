//
//  TSItemStack.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import RxCocoa

/**
 複数個のアイテムを管理するクラスです。
 */
public class TSItemStack {
    // ================================================================= //
    // MARK: - Public Properties -
    /// 対象のアイテムです。
    public let item:TSItem
    
    /// アイテム数です。
    public var count:BehaviorRelay<Int>
    
    // ================================================================= //
    // MARK: - Constructor -
    
    public init(item:TSItem, count:Int = 1) {
        self.item = item
        self.count = BehaviorRelay(value: count)
    }
}

extension TSItemStack :Equatable{
    public static func == (left:TSItemStack, right:TSItemStack) -> Bool {
        return left === right
    }
}
extension TSItemStack :CustomStringConvertible {
    public var description: String {
        return "[TSItemStack item: \(item), count: \(count.value)]"
    }
}
public extension TSItemStack {
    func appendItem(_ count:Int) {
        self.count.accept(self.count.value + count)
    }
    func reduceItem(_ count:Int) {
        self.count.accept(self.count.value - count)
    }
}

public extension TSItemStack {
    static let none = TSItemStack(item: .none, count: 0)
}
