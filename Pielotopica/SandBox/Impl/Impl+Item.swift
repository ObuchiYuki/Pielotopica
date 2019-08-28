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
    
    static let japaneseHouse2 = TS_JapaneseHouse(
        name: "チイサナニホンカオク",
        textureNamed: "TP_item_thumb_japanese_house_2",
        block: .japaneseHouse2
    )
    
    static let woodWall1x5 = TS_WoodWall(
        name: "キノヘイ",
        textureNamed: "TP_item_thumb_wood_wall_1x5",
        block: .woodWall1x5
    )
    
}

