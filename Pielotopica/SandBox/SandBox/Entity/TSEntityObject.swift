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
    
    private weak var world:TSEntityWorld?
    private let animated = false
    
    func removeFromWorld() {
        node.removeFromParentNode()
        world?.removeObject(self)
    }
    func updatePosition(to position:TSVector2, tic:Double) {
        self.position = position
        node.runAction(.move(to: position.vector3(y: 1).scnVector3, duration: tic))
    }
    
    init(world: TSEntityWorld, initialPosition: TSVector2, entity:TSEntity, node:SCNNode) {
        self.world = world
        self.position = initialPosition
        self.entity = entity
        self.node = node
        
        node.position = position.vector3(y: 1).scnVector3
    }
}

