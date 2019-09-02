//
//  TS_TargetBlock.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

class TS_TargetBlock: TSBlock {

    private func _generateNode() -> SCNNode{
        let node = SCNNode()
        
        guard let rootNode = SCNScene(named: "TP_target.scn")?.rootNode else {fatalError()}
        
        guard
            let body = rootNode.childNode(withName: "_palette", recursively: true),
            let p1 = rootNode.childNode(withName: "particle1", recursively: true),
            let p2 = rootNode.childNode(withName: "particle2", recursively: true),
            let p3 = rootNode.childNode(withName: "particle3", recursively: true)
        else {fatalError()}
        
        node.addChildNode(body)
        node.addChildNode(p1)
        node.addChildNode(p2)
        node.addChildNode(p3)
        
        body.runAction(_createBodyAction())
        p1.runAction(_createParticleAction())
        p2.runAction(_createParticleAction())
        p3.runAction(_createParticleAction())

        return node
    }
    
    private func _createParticleAction() -> SCNAction {
        let t = 1.5
        return SCNAction.repeatForever(.sequence([
            SCNAction.run{node in
                node.runAction(SCNAction.group([
                    .move(to: [.random(in: 0.3...2.3), .random(in: 0.6...2), .random(in: 1.2...2.2)], duration: t),
                    .rotateBy(x: .random(in: 0.1...0.2), y: .random(in: 0.1...0.2), z: .random(in: 0.1...0.2), duration: t)
                ]).setEase(.easeInEaseOut))
            },
            .wait(duration: t)
            
        ]))
    }
    
    private func _createBodyAction() -> SCNAction {
        return SCNAction.repeatForever(.sequence([
            SCNAction.move(by: [0,  0.5, 0], duration: 2).setEase(.easeInEaseOut),
            SCNAction.move(by: [0, -0.5, 0], duration: 2).setEase(.easeInEaseOut),
        ]))
    }
    override func createNode() -> SCNNode {
        _generateNode()
    }
    override func getOriginalNodeSize() -> TSVector3 {
        return [2, 2, 2]
    }
    
    override func canDestroy(at point: TSVector3) -> Bool {
        return true
    }
}
