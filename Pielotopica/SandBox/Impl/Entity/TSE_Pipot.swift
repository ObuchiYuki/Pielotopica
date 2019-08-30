//
//  Pipot.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import GameplayKit
import SceneKit

class TSE_Pipot: TSEntity {
    // ======================================================================== //
    // MARK: - Methods -
    override func generateNode() -> SCNNode { _generateNode()}
    
    
    override func update(tic:Double, object:TSEntityObject, world:TSEntityWorld, level:TSLevel) {
        guard let targetPos = level.getAllAnchors().first(where: {level.getAnchorBlock(at: $0) is TS_TargetBlock}) else {
            fatalError("No target found in this level.")
        }
        
        let a = _findpath(from: object.position, to: targetPos.vector2, in: level)
        let from = a[0].position
        let to = a[1].position
        
        let df = CGPoint(x: (to.x - from.x).f, y: (to.y - from.y).f)
        print(object.position, targetPos.vector2, _normalizeVector(df))
        // 🐱 < nyaaaaa! It's raining.
        
        object.updatePosition(to: object.position + _normalizeVector(df), tic: tic)
        
        if object.position.z >= 10 {
            object.removeFromWorld()
        }
    }
    
    private func _normalizeVector(_ vector:CGPoint) -> TSVector2 {
        let (dx, dz) = (vector.x, vector.y)
        
        if abs(dx) >= abs(dz) {
            if dx >= 0 {
                return TSVector2( 1, z: 0)
            }else{
                return TSVector2(-1, z: 0)
            }
        }else{
            if dz >= 0 {
                return TSVector2(0, z:  1)
            }else{
                return TSVector2(0, z: -1)
            }
        }
    }
    
    private func _findpath(from start:TSVector2, to target:TSVector2, in level:TSLevel) -> [GKGraphNode2D] {
        let obstacles = _generateObstacles(from: level)
        let graph = GKObstacleGraph(obstacles: obstacles, bufferRadius: 0)
        print(graph.obstacles)
        
        let startPos = GKGraphNode2D(
            point: vector_float2(Float(start.x), Float(start.z))
        )

        let targetPos = GKGraphNode2D(
            point: vector_float2(Float(target.x), Float(target.z))
        )
        
        graph.connectUsingObstacles(node: startPos)
        graph.connectUsingObstacles(node: targetPos)
        
        if let nodes = graph.findPath(from: startPos, to: targetPos) as? [GKGraphNode2D] {
            return nodes
        }
        
        fatalError("not path found")
    }
    
    /// -10 ~ 10 で探索
    private func _generateObstacles(from level:TSLevel) -> [GKPolygonObstacle] {
        var obstacles = [GKPolygonObstacle]()
        
        for x in -10...10 {
            for z in -10...10 {
                let pos = TSVector3(x, 1, z)
                let block = level.getFillBlock(at: pos)
                if block.isObstacle() {
                    obstacles.append(_createObstacle1x1(at: pos.vector2))
                }
            }
        }
        
        return obstacles
    }
    
    
    
    private func _createObstacle1x1(at point:TSVector2) -> GKPolygonObstacle {
        let p1 = SIMD2<Float>(point.simd)
        let p2 = SIMD2<Float>((point + [0, 1]).simd)
        let p3 = SIMD2<Float>((point + [1, 1]).simd)
        let p4 = SIMD2<Float>((point + [1, 0]).simd)
        
        print([p1, p2, p3, p4])
        return GKPolygonObstacle(points: [p1, p2, p3, p4])
    }
    
    
    
    
    private func _createFootAction(t:Int) -> SCNAction {
        let a1 = SCNAction.rotateBy(x: 0, y: 0, z: -0.5 * CGFloat(t), duration: 0.5)
        a1.timingMode = .easeInEaseOut
        
        let a2 = SCNAction.rotateBy(x: 0, y: 0, z:  0.5 * CGFloat(t), duration: 0.5)
        a2.timingMode = .easeInEaseOut
        
        let a_s = SCNAction.sequence([a1, a2])
        
        return SCNAction.repeatForever(a_s)
    }
    
    private func _generateNode() -> SCNNode {
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
        foot1.runAction(_createFootAction(t:  1))
        
        foot2.eulerAngles = SCNVector3(0, 0, -0.25)
        foot2.runAction(_createFootAction(t: -1))
        
        wnode.addChildNode(battery)
        wnode.addChildNode(foot1)
        wnode.addChildNode(foot2)
        
        wnode.position = [0.5, 0,  0.5]
        wnode.eulerAngles = SCNVector3(0, Double.pi/2, 0)
        node.addChildNode(wnode)
                
        wnode.addChildNode(body)
        
        return node
    }
}


