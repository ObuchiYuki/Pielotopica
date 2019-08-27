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

public class TSInventory {
    
    // ===================================================================== //
    // MARK: - Public Properties -
        
    /// いま持っているアイテム一覧です。
    /// 配列長は常に変わりません。
    public var itemStacks:BehaviorRelay<[TSItemStack]>
    
    // ===================================================================== //
    // MARK: - Public Methods -
    
    
    
    public init(amount:Int) {
        self.itemStacks = BehaviorRelay(value: Array(repeating: .none, count: amount))
        
    }
    
    /// アイテムを追加します。すでにそのアイテムを持っていた場合は、Stackのカウントが増え
    /// 新しいアイテムに対してはStackを追加します。
    public func addItem(_ item:TSItem, count:Int) {
        if let matchingItemStack = self.itemStacks.value.first(where: {$0.item == item}) { // すでに持っていれば
            matchingItemStack.appendItem(count)
        } else {
            let newStack = TSItemStack(item: item, count: count)
            
            self._realAddItemStack(newStack)
        }
        
        //autosave.manualSave()
    }
    
    /// positionにあるアイテムを指定されたアイテムに入れ替えます。
    public func placeItemStack(_ itemStack:TSItemStack, at position:Int) {
        var stacks = self.itemStacks.value
        stacks.remove(at: position)
        stacks.insert(itemStack, at: position)
        
        self.itemStacks.accept(stacks)
        
        //autosave.manualSave()
    }
    
    /// アイテムスタックを追加します。
    public func addItemStack(_ itemStack:TSItemStack) {
        
        self.addItem(itemStack.item, count: itemStack.count.value)
    }
    
    private func _realAddItemStack(_ itemStack:TSItemStack) {
        guard let index = itemStacks.value.firstIndex(where: {$0 == .none}) else {fatalError("This inventry is max! too max!!")}
        
        placeItemStack(itemStack, at: index)
    }
}
