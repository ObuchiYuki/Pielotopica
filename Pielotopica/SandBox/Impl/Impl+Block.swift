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
    static let air:TSBlock = TS_Air()
        
    static let japaneseHouse2:TSBlock = TS_JapaneseHouse2(nodeNamed: "TP_japanese_house_2", index: 1)
    
    static let ground5x5:TSBlock = TS_Floar5x5(nodeNamed: "TP_ground_5x5", index: 12)
    
    static let ground5x5Edge:TSBlock = TS_Floar5x5(nodeNamed: "TP_Ground_edge", index: 13)
    
    static let woodWall1x5:TSBlock = TS_Wall1x5(nodeNamed: "TP_wood_wall_1x5", index: 14)
}

