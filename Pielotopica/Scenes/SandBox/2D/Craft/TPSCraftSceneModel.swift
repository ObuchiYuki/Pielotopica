//
//  TPSCraftSceneModel.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

protocol TPSCraftSceneModelBinder: class{
    var __itemBarSelectedIndex:Int { get }
    
    func __changeCraftMenu(with item:TSItem)
    func __placeItemBar(with item: TSItemStack, at index: Int)
}

class TPSCraftSceneModel: TPSandBoxSceneModel {
    private weak var binder:TPSCraftSceneModelBinder!
    
    init(_ binder:TPSCraftSceneModelBinder) {
        self.binder = binder
    }
    
    func onBackAction() {
        self.rootSceneModel.present(to: TPSBuildScene(), as: .build)
    }
    
    
    func onIndexChange(to index:Int) {
        let item = TPCraftMoreItems.showingItems.at(index) ?? .none
        
        binder.__changeCraftMenu(with: item)
        
        if item == .none {return}
        
        if let existingIndex = TSItemBarInventory.itembarShared.itemStacks.value.firstIndex(where: {$0.item == item}) {
            binder.__placeItemBar(with: .none, at: existingIndex)
        }
        
        guard let itemStack = TSInventory.shared.itemStacks.value.first(where: {$0.item == item})
            else {return}

        binder.__placeItemBar(with: itemStack, at: binder.__itemBarSelectedIndex)
        
    }
}
