//
//  TSEntityObject.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

/// World上に存在するEntityの実体です。(Entityの実体...頭痛が痛い...)
/// 本当はTSEntityEntityにしたかった。
class TSEntityObject {
    var position:TSVector2
    let entity:TSEntity
    let node:SCNNode
    
    init(initialPosition: TSVector2, entity:TSEntity, node:SCNNode) {
        self.position = initialPosition
        self.entity = entity
        self.node = node
    }
}
