//
//  TSItemStacksData.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/27.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

struct TSItemStacksData: RMAutoSavable {
    let itemIndex:UInt16
    let count:Int
    
    var itemStack:TSItemStack {
        let item = TSItem.item(for: itemIndex)
        return TSItemStack(item: item, count: count)
    }

    init() {
        itemIndex = 0
        count = 0
    }
    init(itemStack: TSItemStack) {
        self.itemIndex = itemStack.item.index
        self.count = itemStack.count.value
    }
}
