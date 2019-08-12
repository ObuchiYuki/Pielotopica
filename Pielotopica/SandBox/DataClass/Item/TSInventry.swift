//
//  TSInventry.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/05.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import RxCocoa

///  プレイヤーの持ち物を表します。

public class TSInventry {
    // ===================================================================== //
    // MARK: - Public Properties -
    
    /// TSInventryに追加できる最大のアイテムスタック数です。
    public let maximumItemStackCount:Int
    
    /// いま持っているアイテム一覧です。
    /// 配列長は常に変わりません。
    public var itemStacks:BehaviorRelay<[TSItemStack]>
    
    // ===================================================================== //
    // MARK: - Public Properties -
    
    public init(amount:Int) {
        self.maximumItemStackCount = amount
        self.itemStacks = BehaviorRelay(value: Array(repeating: .none, count: amount))
    }
    
    /// アイテムが追加できるかどうかを返します。
    public func canAddItem(_ item:TSItem) -> Bool {
        if itemStacks.value.contains(where: {$0.item == item}) {
            return true
        } else {
            return self.itemStacks.value.count < self.maximumItemStackCount
        }
    }
    
    /// アイテムを追加します。すでにそのアイテムを持っていた場合は、Stackのカウントが増え
    /// 新しいアイテムに対してはStackを追加します。
    public func addItem(_ item:TSItem, count:Int) {
        assert(canAddItem(item), "Cannot add items \(item), Please check canAddItem first")
        
        if let matchingItemStack = self.itemStacks.value.first(where: {$0.item == item}) {
            matchingItemStack.appendItem(count)
        } else {
            let newStack = TSItemStack(item: item, count: count)
            self.addItemStack(newStack)
        }
    }
    
    /// positionにあるアイテムを指定されたアイテムに入れ替えます。
    public func placeItemStack(_ itemStack:TSItemStack, at position:Int) {
        var stacks = self.itemStacks.value
        stacks.remove(at: position)
        stacks.insert(itemStack, at: position)
        
        self.itemStacks.accept(stacks)
    }
    
    /// アイテムスタックが追加できるかを試します。
    public func canAddemStack(_ itemStack:TSItemStack) -> Bool {
        return !( self.itemStacks.value.filter{$0 == .none}.isEmpty )
    }
    
    /// アイテムスタックを追加します。
    /// （.noneが存在すれば、.noneを入れ替えます。）
    public func addItemStack(_ itemStack:TSItemStack) {
        guard canAddemStack(itemStack) else {
            return debugPrint("Cannot add itemStack to this TSInventry. Please check canAddemStack first.")
        }
        
        guard let index = self.itemStacks.value.firstIndex(where: {$0 == .none}) else {
            return
        }
        
        self.placeItemStack(itemStack, at: index)
    }
}
