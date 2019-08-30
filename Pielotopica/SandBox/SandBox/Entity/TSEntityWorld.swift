//
//  TSEntityWorld.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import GameplayKit

protocol TSEntityWorldDelegate: class {
    func addNode(_ node: SCNNode)
}

/// 動的オブジェクトが入る場所です。
class TSEntityWorld {
    
    typealias WorldGraph = GKObstacleGraph<GKGraphNode2D>
    // ================================================================== //
    // MARK: - Properties -
    
    /// この世界に存在するエンティティ
    var entities = [TSEntityObject]()
    private weak var delegate:TSEntityWorldDelegate!
    
    // ================================================================== //
    // MARK: - Private Properties -
    private var graph:WorldGraph!
    
    private var spowners = [TSVector2: TSSpawner]()
    private var counter = 0
    private var updateInterval = 0.5
    private var timer:Timer? = nil
    
    private var targetNode:GKGraphNode2D!
    
    // ================================================================== //
    // MARK: - Methods -
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: {[weak self] timer in
            guard let self = self else { return timer.invalidate() }
            self._update()
            self._spawnUpdate()
            
        })
        self.graph = _generateGraph()
        
        _getAllSpawners().forEach{spowners[$0] = $1}
    }
    
    func end() {
        self.entities.forEach{ $0.removeFromWorld() }
        self.entities = []
        self.timer?.invalidate()
        self.spowners = [:]
    }
    
    func removeObject(_ object:TSEntityObject) {
        guard let index = entities.firstIndex(where: {$0 === object}) else {return print("Not found")}
        entities.remove(at: index)
    }
    
    func findPathToTarget(from node:GKGraphNode2D) -> [CGPoint] {
        let ns = self.graph.findPath(from: targetNode, to: node) as! [GKGraphNode2D]
        
        return ns.map{CGPoint(x: CGFloat($0.position.x), y: CGFloat($0.position.y))}
    }
    
    // ================================================================== //
    // MARK: - Construcotr -
    
    init(delegate:TSEntityWorldDelegate) {
        self.delegate = delegate
    }

    
    // ================================================================== //
    // MARK: - Private Methods -
    
    private func _getTargetPosition() -> TSVector2 {
        let level = TSLevel.current!
        
        let pos = level.getAllAnchors().first(where: {level.getAnchorBlock(at: $0) is TS_TargetBlock})
        assert(pos != nil, "You must set single target in level.")
        
        return pos!.vector2
    }
    
    
    private func _generateGraph() -> WorldGraph {
        let graph = WorldGraph(obstacles: _generateObstacles(from: TSLevel.current), bufferRadius: 0.45)
        
        for (pos, spowner) in _getAllSpawners() {
            let node = GKGraphNode2D(point: vector_float2(Float(pos.x), Float(pos.z)))
            spowner.targetNode = node
            
            graph.connectUsingObstacles(node: node)
        }
        
        let targetPos = _getTargetPosition()
        
        targetNode = GKGraphNode2D(point: vector_float2(Float(targetPos.x), Float(targetPos.z)))
        graph.connectUsingObstacles(node: targetNode)
        
        return graph
    }
    private func _generateObstacles(from level:TSLevel) -> [GKPolygonObstacle] {
        var obstacles = [GKPolygonObstacle]()
        
        for anchor in level.getAllAnchors() {
            let block = level.getAnchorBlock(at: anchor)
            
            if block.isObstacle() {
                let sizef = block.getSize(at: anchor).vector2
                obstacles.append(_createObstacle(with: sizef, at: anchor.vector2))
            }
        }
        
        return obstacles
    }
    
    private func _createObstacle(with size:TSVector2, at point:TSVector2) -> GKPolygonObstacle {
        let p1 = SIMD2<Float>(point.simd)
        let p2 = SIMD2<Float>((point + [0, size.z16]).simd)
        let p3 = SIMD2<Float>((point + size).simd)
        let p4 = SIMD2<Float>((point + [size.x16, 0]).simd)
        
        return GKPolygonObstacle(points: [p1, p2, p3, p4])
    }
    
    private func _update() {
        for entity in entities  {
            entity.entity.update(tic: updateInterval, object: entity, world: self, level: TSLevel.current)
        }
    }
    
    private func _spawnUpdate() {
        
        for (point, spowner) in spowners {
            /// 一回呼ばれるのに何1/2秒かかるか
            let t = Int((1.0 / spowner.frequency.d) * 100 / updateInterval)
            
            if counter % t == 0 {
                let obj = TSEntityObject(
                    world: self, initialPosition: point,
                    entity: spowner.entity, node: spowner.entity.generateNode(),
                    spown: spowner
                )
                
                entities.append(obj)
                delegate.addNode(obj.node)
            }
        }
        
        // 1秒に2回呼ばれる
        counter += 1
    }
    
    private func _getAllSpawners() -> [(TSVector2, TSSpawner)] {
        let level = TSLevel.current!
        
        let spawnerBlocks = level.getAllAnchors()
            .map{($0, level.getAnchorBlock(at: $0))}
            .filter { $1 is TS_SpawnerBlock }
            
        let spawnerPositions = spawnerBlocks
            .map{$0.0.vector2}
        
        let spowners = spawnerBlocks
            .map{$1 as! TS_SpawnerBlock}
            .map(TSSpawner.init(block: ))
     
        return zip(spawnerPositions, spowners).map{$0}
    }
    
}
