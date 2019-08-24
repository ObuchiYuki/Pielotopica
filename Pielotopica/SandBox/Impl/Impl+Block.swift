//
//  Ex+TSBlock.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

// TSBlockへの登録
public extension TSBlock {

    /// air
    static let air:TSBlock = TSBlock()
        
    static let japaneseHouse2:TSBlock = JapaneseHouse2(nodeNamed: "TP_japanese_house_2", index: 1)
    
    static let normalFloar5x5:TSBlock = TPFloar(nodeNamed: "TP_floar_5x5", index: 2)
    
    static let ground5x5:TSBlock = TPFloar(nodeNamed: "TP_ground_5x5", index: 12)
    
    static let ground5x5Edge:TSBlock = TPFloar(nodeNamed: "TP_Ground_edge", index: 13)
    
    static let woodWall1x5:TSBlock = TSWall(nodeNamed: "TP_wood_wall_1x5", index: 14)
    
    static let woodWall1x1:TSBlock = TSWall1(nodeNamed: "TP_wood_wall_1x1", index: 15)
}

