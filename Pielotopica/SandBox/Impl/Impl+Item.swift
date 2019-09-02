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
    static let none = TSItem(name: "", index: 0, textureNamed: "TP_none")
    
    static let japaneseHouse2 = TSI_JapaneseHouse(
        name: "チイサナニホンカオク",
        textureNamed: "TP_item_thumb_japanese_house_2",
        block: .japaneseHouse2
    )
    
    static let woodWall1x5 = TSI_WoodWall(
        name: "キのヘイ",
        textureNamed: "TP_item_thumb_wood_wall_1x5",
        block: .woodWall
    )
    
    static let pipotSpawner = TSI_SpawnerItem(
        name: "ピポットのスポナー",
        textureNamed: "TP_item_thumb_spawner",
        block: .pipotSpawner
    )
    
    static let targetKari = TSI_KariItem(
        name: "カリのキョテン",
        textureNamed: "TP_item_thumb_kari",
        block: .targetKari
    )
    
    static let kiKari = TSI_KariItem(
        name: "カリの木",
        textureNamed: "TP_item_thumb_tree",
        block: .tree
    )
    
    static let stoneKari = TSI_KariItem(
        name: "カリの岩",
        textureNamed: "TP_item_thumb_kari",
        block: .stone
    )
    
    static let grassKari = TSI_KariItem(
        name: "カリの茂み",
        textureNamed: "TP_item_thumb_grass",
        block: .grass
    )
    
    static let ironWall = TSI_KariItem(
        name: "テツのカベ",
        textureNamed: "TP_item_thumb_iron_wall",
        block: .ironWall
    )
}

