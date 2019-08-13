//
//  Ex+TSBlock.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

// MARK: - これ実態はImplなので修正してください。

import SceneKit

// TSBlockへの登録
public extension TSBlock {

    /// air
    static let air:TSBlock = TSBlock()
    
    static let largeJapanaeseHouse:TSBlock = LargeJapaneseHouse(nodeNamed: "TP_japanese_house_1", index: 3)
    
    static let japaneseHouse2:TSBlock = TSBlock(nodeNamed: "TP_japanese_house_2", index: 1)
    
    static let normalFloar5x5:TSBlock = NormalFloar5x5(nodeNamed: "TP_floar_5x5", index: 2)
}

// TSItemへの登録
public extension TSItem {
    static let none = TSItem(name: "", index: 0, textureNamed: "TP_nil")
    
    static let japaneseHouse1 = TSBlockItem(name: "オオキナニホンカオク", textureNamed: "TP_item_thumb_japanese_house_1", block: .largeJapanaeseHouse)
    
    static let japaneseHouse2 = TSBlockItem(name: "チイサナニホンカオク", textureNamed: "TP_item_thumb_japanese_house_2", block: .japaneseHouse2)
    
    static let normalFloar5x5 = TSBlockItem(name: "チュウクライノユカ", textureNamed: "TS_none", block: .normalFloar5x5)
}

