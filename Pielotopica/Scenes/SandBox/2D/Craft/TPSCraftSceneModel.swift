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
    
    func __checkCraftableState()
    func __changeCraftMenu(with item:TSItem)
    func __placeItemBar(with item: TSItemStack, at index: Int)
}

class TPSCraftSceneModel: TPSandBoxSceneModel {
    // ===================================================================== //
    // MARK: - Properties -
    
    private weak var binder:TPSCraftSceneModelBinder!
    
    private var selectedItem:TSItem?
    // ===================================================================== //
    // MARK: - Construcotr -
    init(_ binder:TPSCraftSceneModelBinder) {
        self.binder = binder
    }
    
    // ===================================================================== //
    // MARK: - Handler -
    func onBackAction() {
        if rootSceneModel.isBattle {
            self.rootSceneModel.present(to: TPSBattleScene())
        }else{
            self.rootSceneModel.present(to: TPSBuildScene())
        }
    }
    
    func onCraftTap() {
        guard let item = selectedItem, let material = item.materialsForCraft() else {return print("Cannot be here.")}
        
        TSMaterialData.shared.addIron(-material.iron)
        TSMaterialData.shared.addWood(-material.wood)
        TSMaterialData.shared.addCircit(-material.circit)
        
        TSFuelData.shared.addFuel(-material.fuel)
        
        TSInventory.shared.addItem(item, count: item.amountCanCreateAtOnce())
        
        binder.__checkCraftableState()
    }
    
    func onIndexChange(to index:Int) {
        let item = TPCraftMoreItems.showingItems.at(index) ?? .none
        
        binder.__changeCraftMenu(with: item)
        self.selectedItem = item
        
        if item == .none {return}
        
        if let existingIndex = TSItemBarInventory.itembarShared.itemStacks.value.firstIndex(where: {$0.item == item}) {
            binder.__placeItemBar(with: .none, at: existingIndex)
        }
        
        guard let itemStack = TSInventory.shared.itemStacks.value.first(where: {$0.item == item})
            else {return}

        binder.__placeItemBar(with: itemStack, at: binder.__itemBarSelectedIndex)
        
    }
}
