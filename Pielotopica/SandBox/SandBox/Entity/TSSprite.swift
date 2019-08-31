//
//  TSSprite.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import SpriteKit

class TSSprite {
    let sprite:SKSpriteNode
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
    }
    
    func show(at position:SCNVector3, in scene:SCNScene) {
        let _node = SCNNode()
        let plane = SCNPlane(width: sprite.size.width / 100, height: sprite.size.height / 100)
        plane.firstMaterial?.diffuse.contents = _createSKScene()
        
        _node.geometry = plane
        _node.position = position
                
        _node.constraints = [SCNBillboardConstraint()]
        
        scene.rootNode.addChildNode(_node)
    }
    
    private func _createSKScene() -> SKScene {
        let scene = SKScene(size: sprite.size)
        scene.addChild(sprite)
        return scene
    }
}
