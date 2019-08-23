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
    static let none = TSItem(name: "<none>", index: 0, textureNamed: "TP_none")
    
    static let japaneseHouse1 = TSBlockItem(
        name: "オオキナニホンカオク", textureNamed: "TP_item_thumb_japanese_house_1", block: .largeJapanaeseHouse)
    
    static let japaneseHouse2 = TSBlockItem(
        name: "チイサナニホンカオク", textureNamed: "TP_item_thumb_japanese_house_2", block: .japaneseHouse2)
    
    static let woodWall1x5 = TSBlockItem(
        name: "キノヘイ", textureNamed: "TP_item_thumb_wood_wall_1x5", block: .woodWall1x5)
    
    
    static let normalFloar5x5 = TSBlockItem(
        name: "チュウクライノユカ", textureNamed: "TS_none", block: .normalFloar5x5)
    
    
}

