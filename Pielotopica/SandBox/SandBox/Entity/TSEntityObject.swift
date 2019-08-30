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
    var position:CGPoint
    var info = [String:Any]()
    let entity:TSEntity
    let node:SCNNode
    
    private weak var world:TSEntityWorld?
    private let animated = false
    
    func removeFromWorld() {
        node.removeFromParentNode()
        world?.removeObject(self)
    }
    func updatePosition(to position:CGPoint, tic:Double) {
        self.position = position
        node.runAction(.move(to: SCNVector3(x: Float(position.x), y: 1, z: Float(position.y)), duration: tic))
    }
    
    init(world: TSEntityWorld, initialPosition: TSVector2, entity:TSEntity, node:SCNNode) {
        self.world = world
        self.position = initialPosition.point
        self.entity = entity
        self.node = node
        
        node.position = SCNVector3(x: Float(position.x), y: 1, z: Float(position.y))
    }
}

