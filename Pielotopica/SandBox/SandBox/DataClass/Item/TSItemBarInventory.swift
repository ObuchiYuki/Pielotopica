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
public class TSItemBarInventory: TSInventory {

    // ========================================================== //
    // MARK: - Properties -
    /// 現在選択中のアイテム番号です。(0-3)
    public var selectedItemIndex = BehaviorRelay(value: 0)
    
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
    }
    
    // ========================================================== //
    // MARK: - Private Methods -
    /// indexのアイテムを入れ替えます。
    private func _changeItemStack(at index:Int, to itemStack: TSItemStack) {
        var stack = self.itemStacks.value
        stack.remove(at: index)
        stack.insert(itemStack, at: index)
        
        self.itemStacks.accept(stack)
    }
    
    // ========================================================== //
    // MARK: - Constructer -
    public init() {
        super.init(amount: 4)
    
    }
}
