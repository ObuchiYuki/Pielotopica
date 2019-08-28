//
//  TSInventoryData.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/27.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

struct TSInventoryData: RMAutoSavable {
    let itemStacks:[TSItemStacksData]
    
    init() {
        self.itemStacks = []
    }
    init(inventory:TSInventory) {
        self.itemStacks = inventory.itemStacks.value.map(TSItemStacksData.init(itemStack: ))
    }
}


