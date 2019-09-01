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
        name: "キのヘイ",
        textureNamed: "TP_item_thumb_wood_wall_1x5",
        block: .woodWall1x5
    )
    
    static let pipotSpawner = TS_SpawnerItem(
        name: "ピポットのスポナー",
        textureNamed: "TP_item_thumb_spawner",
        block: .pipotSpawner
    )
    
    static let targetKari = TS_KariItem(
        name: "カリのキョテン",
        textureNamed: "TP_item_thumb_target_kari",
        block: .targetKari
    )
    
    static let kiKari = TS_KariItem(
        name: "カリの木",
        textureNamed: "TP_item_thumb_kari",
        block: .tree
    )
    
    static let stoneKari = TS_KariItem(
        name: "カリの岩",
        textureNamed: "TP_item_thumb_kari",
        block: .stone
    )
}

