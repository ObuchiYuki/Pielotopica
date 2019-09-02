//
//  TSItemManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TSItemManager {
    static let shared = TSItemManager()
    
    func visibleItems() -> [TSItem] {
        registeredItem.filter{ $0.isVisible() }
    }
    func getCreatableItems() -> [TSItem] {
        return registeredItem.filter{ $0.materialsForCraft() != nil }
    }
    
    private var registeredItem = [TSItem]()
    
    func register(_ item:TSItem) {
        registeredItem.append(item)
    }
}
