//
//  TSItemBarInventory.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/06.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import RxCocoa

/**
 4つのみスタックを持つアイテムバー用のインベントリです。
 */

extension Int: RMAutoSavable {}

private struct Movements: RMAutoSavable {
    private static let _autosave = RMAutoSave<Movements>("__TSItemBarInventory_movement_autosave_key")
    static var shared:Movements {
        get{
            _autosave.value ?? Movements(movements: [])
        }
        set{
            _autosave.value = newValue
        }
    }
    
    var movements:[Movement]
    
    mutating func addMovement(from: Int, to:Int) {
        movements = movements.filter{$0.from !=  from && $0.to != to}
        
        movements.append(Movement(from: from, to: to))
    }
    
}
private struct Movement: RMAutoSavable {
    let from:Int
    let to:Int
}

public class TSItemBarInventory: TSInventory {
    
    static let itembarShared = TSItemBarInventory(maxAmount: 4)
    
    private static var _indexAutosave = RMAutoSave<Int>("__TSItemBarInventory_index_autosave_key")
    
    // ========================================================== //
    // MARK: - Properties -
    /// 現在選択中のアイテム番号です。(0-3)
    
    func setSelectedItemIndex(_ _selectedItemIndex:Int) {
        TSItemBarInventory._indexAutosave.value = _selectedItemIndex
        
        selectedItemIndex.accept(_selectedItemIndex)
    }
    
    lazy var selectedItemIndex = BehaviorRelay(value: TSItemBarInventory._indexAutosave.value ?? 0)
    
    /// 現在選択中のアイテムです。
    public var selectedItemStack:TSItemStack {
        return self.itemStacks.value[selectedItemIndex.value]
    }
    
    // ========================================================== //
    // MARK: - Methods -
    public func canUseCurrentItem(_ amount:Int = 1) -> Bool {
        return self.selectedItemStack.count.value >= amount
    }
    
    /// 現在選択中のアイテムを使用します。
    public func useCurrentItem(_ amount:Int = 1) {
        guard canUseCurrentItem(amount) else {
            return debugPrint("Cannot use current with amount \(amount). Please check canUseCurrentItem first.")
        }
        
        selectedItemStack.count.accept(selectedItemStack.count.value - amount)
        
        /// 0になったら、
        if selectedItemStack.count.value == 0 {
            var stack = itemStacks.value
            stack.remove(at: selectedItemIndex.value)
            stack.insert(.none, at: selectedItemIndex.value)
            
            itemStacks.accept(stack)
        }
        
        TSInventory.shared._saveSelf()
    }
    
    /// positionにあるアイテムを指定されたアイテムに入れ替えます。
    public func placeItemStack(from inventoryPosition:Int, at position:Int) {
        let itemStack:TSItemStack
        
        if inventoryPosition < 0 {
            itemStack = .none
        }else{
            itemStack = TSInventory.shared.itemStacks.value[inventoryPosition]
        }
        
        var stacks = self.itemStacks.value
        stacks.remove(at: position)
        stacks.insert(itemStack, at: position)
        
        Movements.shared.addMovement(from: inventoryPosition, to: position)
        
        self.itemStacks.accept(stacks)
        
        _saveSelf()
    }
    
    public override init(maxAmount: Int) {
        super.init(maxAmount: maxAmount)
        
        _loadOrder()
    }
    // ========================================================== //
    // MARK: - Private Methods -
    
    private func _loadOrder() {
        for move in Movements.shared.movements {
            placeItemStack(from: move.from, at: move.to)
        }
    }
    
    override func _saveSelf() {}
    
    override func _autosaved() -> [TSItemStack]? {
        return []
    }
    /// indexのアイテムを入れ替えます。
    private func _changeItemStack(at index:Int, to itemStack: TSItemStack) {
        var stack = self.itemStacks.value
        stack.remove(at: index)
        stack.insert(itemStack, at: index)
        
        self.itemStacks.accept(stack)
        
        _saveSelf()
    }
}
