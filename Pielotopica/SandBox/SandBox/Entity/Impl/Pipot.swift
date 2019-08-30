//
//  Pipot.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import GameKit
import SceneKit

class TSA_Pipot: TSEnemyAI {
    
    override func findRoute(from fromPoint: TSVector2, to toPoint: TSVector2, in level: TSLevel) -> [TSVector2] {
        return
    }
}

class TSE_Pipot: TSEnemy {
    lazy var ai = TSA_Pipot()
    
    override func getAI() -> TSEnemyAI {
        return ai
    }
    override func walkAction() -> SCNAction {
        SCNAction.customAction(duration: 0.5, action: {node, time in
            let foot1 = node.childNode(withName: "foot1", recursively: true)
            
            
        })
        let a1 = SCNAction.rotateBy(x: 0, y: 0, z: -0.5 * CGFloat(t), duration: 0.5)
        a1.timingMode = .easeInEaseOut
        
        let a2 = SCNAction.rotateBy(x: 0, y: 0, z:  0.5 * CGFloat(t), duration: 0.5)
        a2.timingMode = .easeInEaseOut
        
        let a_s = SCNAction.sequence([a1, a2])
        
        return SCNAction.repeatForever(a_s)
    }
    
    override func createNode() -> SCNNode {
        let node = SCNNode()
        let wnode = SCNNode()
        
        guard
            let scene = SCNScene(named: "enemy_1.scn")
        else {fatalError()}
        
        guard
            let body = scene.rootNode.childNode(withName: "body", recursively: true),
            let foot1 = scene.rootNode.childNode(withName: "foot1", recursively: true),
            let foot2 = scene.rootNode.childNode(withName: "foot2", recursively: true),
            let battery = scene.rootNode.childNode(withName: "battery", recursively: true)
        else {fatalError()}
                
        foot1.eulerAngles = SCNVector3(0, 0, 0.25)
        
        foot2.eulerAngles = SCNVector3(0, 0, -0.25)
        
        wnode.addChildNode(battery)
        wnode.addChildNode(foot1)
        wnode.addChildNode(foot2)
        
        wnode.eulerAngles = SCNVector3(0, Double.pi/2, 0)
        node.addChildNode(wnode)
                
        wnode.addChildNode(body)
        
        return node
    }
}


