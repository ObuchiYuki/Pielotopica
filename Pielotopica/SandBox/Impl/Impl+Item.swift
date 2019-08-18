//
//  Impl+Item.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation


// TSItemへの登録
public extension TSItem {
    static let none = TSItem(name: "<nil>", index: 0, textureNamed: "TP_nil")
    
    static let japaneseHouse1 = TSBlockItem(name: "オオキナニホンカオク", textureNamed: "TP_item_thumb_japanese_house_1", block: .largeJapanaeseHouse)
    
    static let japaneseHouse2 = TSBlockItem(name: "チイサナニホンカオク", textureNamed: "TP_item_thumb_japanese_house_2", block: .japaneseHouse2)
    
    static let normalFloar5x5 = TSBlockItem(name: "チュウクライノユカ", textureNamed: "TS_none", block: .normalFloar5x5)
}
