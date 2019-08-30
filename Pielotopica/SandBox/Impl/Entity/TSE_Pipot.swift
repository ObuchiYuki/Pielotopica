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
    
    static let astr = AStar(size: 20)
    
    private var foundRoutes = [TSVector2:[TSVector2]]()
    
    private func getRoute(from spownPosition: TSVector2, in level:TSLevel) -> [TSVector2] {
        RMMeasure.start(label: "1")
        if let found = foundRoutes[spownPosition] { return found }
        
        guard let targetPos = level.getAllAnchors().first(where: {level.getAnchorBlock(at: $0) is TS_TargetBlock}) else {
            fatalError("No target found in this level.")
        }
        
        let a = _findpath(from: spownPosition, to: targetPos.vector2, in: level).map(TSVector2.init)
            
        assert(!a.isEmpty, "noway! \(spownPosition), \(targetPos.vector2)")
        
        foundRoutes[spownPosition] = a
        RMMeasure.end(label: "1")
        return a
    }
    
    override func update(tic:Double, object:TSEntityObject, world:TSEntityWorld, level:TSLevel) {
        if object.info["spown"] == nil { object.info["spown"] = object.position }
        guard let spownPoint = object.info["spown"] as? TSVector2 else {fatalError()}
        
        let route = getRoute(from: spownPoint, in: level)
        
        if object.info["index"] == nil { object.info["index"] = 0 }
        guard let index = object.info["index"] as? Int else {fatalError()}
        
        if route.count <= index + 1 {
            object.removeFromWorld()
            return
        }
        
        let from = route[index]
        let to = route[index + 1]
        
        object.info["index"] = index + 1
        
        let df = CGPoint(x: (to.x - from.x).f, y: (to.z - from.z).f)
        
        object.updatePosition(to: object.position + _normalizeVector(df), tic: tic)
        
        if object.position.z >= 30 {
            object.removeFromWorld()
        }
    }
    
    private func _normalizeVector(_ vector:CGPoint) -> TSVector2 {
        let (dx, dz) = (vector.x, vector.y)
        
        let ab = abs(sqrt(dx * dx + dz * dz))

        return TSVector2((dx / ab).i, (dz / ab).i)
    }
    
    private func _findpath(from start:TSVector2, to target:TSVector2, in level:TSLevel) -> [CGPoint] {
        
        let obstacles = _generateObstacles(from: level)
        let graph = GKObstacleGraph(obstacles: obstacles, bufferRadius: 0)
        
        let startPos = GKGraphNode2D(
            point: vector_float2(Float(start.x), Float(start.z))
        )

        let targetPos = GKGraphNode2D(
            point: vector_float2(Float(target.x), Float(target.z))
        )
        
        graph.connectUsingObstacles(node: startPos)
        graph.connectUsingObstacles(node: targetPos)
        
        if let nodes = graph.findPath(from: startPos, to: targetPos) as? [GKGraphNode2D] {
            return nodes.map{ CGPoint(x: $0.position.x.f, y: $0.position.y.f) }
        }
        
        return []
    }
    
    /// -20 ~ 20 で探索
    private func _generateObstacles(from level:TSLevel) -> [GKPolygonObstacle] {
        var obstacles = [GKPolygonObstacle]()
        
        for x in -20...20 {
            for z in -20...20 {
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
        let p2 = SIMD2<Float>((point + [1, 0]).simd)
        let p3 = SIMD2<Float>((point + [1, 1]).simd)
        let p4 = SIMD2<Float>((point + [0, 1]).simd)
        
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


