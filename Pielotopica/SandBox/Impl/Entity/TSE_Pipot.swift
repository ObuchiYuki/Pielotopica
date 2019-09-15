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

extension GKGraphNode2D {
    convenience init(_ point:CGPoint) {
        self.init(point: vector_float2(Float(point.x), Float(point.y)))
    }
}

class TSE_Pipot: TSEntity {
    private let manager = TSTerrainManager.shared
    let speed:CGFloat = 1
    
    // ======================================================================== //
    // MARK: - Methods -
    override func generateNode() -> SCNNode { _generateNode()}
    
    override func update(tic:Double, object:TSEntityObject, world:TSEntityWorld) {
        RMMeasure.start()
        let route = world.findPathToTarget(from: object.spown.node!, speed: speed)
        
        var vector:CGPoint
        
        if object.info["random"] == nil {
            object.info["random"] = CGPoint.random(x: -0.1...0.1, y: -0.1...0.1)
        }
        let random = object.info["random"] as! CGPoint
        
        
        if !route.isEmpty {
            
            if object.info["index"] == nil {object.info["index"]=0}; let index = object.info["index"] as! Int
            object.info["index"] = index + 1
            
            if route.count <= index {
                vector = _routeToTarget(object: object, world: world)
            }else{
                vector = route[index]
            }
        }else{
            vector = _routeToTarget(object: object, world: world)
        }
        
        
        let next = TSVector2(object.position + vector)
        
        
        if manager.getFill(at: next.vector3(y: 1)).isObstacle() {
            let anc = manager.getAnchor(ofFill: next.vector3(y: 1))!
            TSDurablityManager.shared.attack(1, at: anc)
            
        }else{
            object.node.childNodes[0].runAction(.rotateTo(x: 0, y: _angle(from: vector), z: 0, duration: 0.1))
            object.updatePosition(to: object.position + vector + random, tic: tic)
            
        }
        
        
        if (object.position).isNear(to: world.getTargetPosition().point, distanceThreshold: 1) {
            TPGameController.initirized?.end(with: .gameover)
            
        }
        
        RMMeasure.end()
    }
    
    // ======================================================================== //
    // MARK: - Private Methods -
    
    private func _routeToTarget(object:TSEntityObject, world:TSEntityWorld) -> CGPoint {
        
        return (world.getTargetPosition().point - object.position).normarized
    }
    
    private func _angle(from route:CGPoint) -> CGFloat {
        return atan2(route.x, route.y) + .pi/2
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
                
        //foot1.eulerAngles = SCNVector3(0, 0, 0.25)
        //foot1.runAction(_createFootAction(t:  1))
        
        //foot2.eulerAngles = SCNVector3(0, 0, -0.25)
        //foot2.runAction(_createFootAction(t: -1))
        
        wnode.addChildNode(battery)
        wnode.addChildNode(foot1)
        wnode.addChildNode(foot2)
        wnode.scale = SCNVector3(0.5, 0.5, 0.5)
        wnode.position = [0.5, 0,  0.5]
        wnode.eulerAngles = SCNVector3(0, Double.pi/2, 0)
        node.addChildNode(wnode)
                
        wnode.addChildNode(body)
        
        return node
    }
}


