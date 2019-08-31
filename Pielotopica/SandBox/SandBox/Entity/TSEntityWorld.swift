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
    private var fillObstacles = [TSVector2: GKPolygonObstacle]()
     
    // ================================================================== //
    // MARK: - Methods -
    func start() {
        self.graph = _generateGraph()
        
        self._getAllSpawners().forEach{spowners[$0] = $1}
        
        self.timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: {[weak self] timer in
            guard let self = self else { return timer.invalidate() }
            self._update()
            self._spawnUpdate()
            
        })
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
    
    func findPathToTarget(from node: GKGraphNode2D, speed: CGFloat) -> [CGPoint] {
        let ns = self.graph.findPath(from: node, to: targetNode) as! [GKGraphNode2D]
        let ps = ns.map{CGPoint(x: CGFloat($0.position.x), y: CGFloat($0.position.y))}
        let ss = split(ps, speed)
        
        return ss
    }
    
    private func split(_ line: [CGPoint],_ stride:CGFloat) -> [CGPoint] {
        if line.count <= 1 {return line}
        var points = [CGPoint]()
        
        func dist(a:CGPoint, b: CGPoint) -> CGFloat { sqrt((a.x-b.x) * (a.x-b.x) + (a.y-b.y) * (a.y-b.y)) }
        func normal(a:CGPoint, b: CGPoint) -> CGPoint { (b - a) / dist(a: a, b: b) * stride }
        
        for i in 0..<line.count-1 {
            let d = dist(a: line[i], b: line[i+1])
            for _ in 0..<Int(d / stride) { points.append(normal(a: line[i], b: line[i+1])) }
            points.append(line[i+1] - line[i] - normal(a: line[i], b: line[i+1]) * Int(d / stride))
        }
        return points
    }
    
    // ================================================================== //
    // MARK: - Construcotr -
    
    init(delegate:TSEntityWorldDelegate) {
        self.delegate = delegate
    }
    
    // ================================================================== //
    // MARK: - Private Methods -
    
    private func _addObsracles(at points:[TSVector2]) {
        self.graph.addObstacles(points.map(_createObstacle1x1))
        
    }
    private func _removeObstacles(at points:[TSVector2]) {
        let obss = points.compactMap({fillObstacles[$0]})
        self.graph.removeObstacles(obss)
    }
    
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
            
            spowner.node = node
            
            graph.connectUsingObstacles(node: node)
        }
        
        let targetPos = _getTargetPosition()
        
        targetNode = GKGraphNode2D(point: vector_float2(Float(targetPos.x), Float(targetPos.z)))
        graph.connectUsingObstacles(node: targetNode)
        
        
        return graph
    }
    
    private func _generateWalls() -> [GKPolygonObstacle] {
        return [
            GKPolygonObstacle(points: [
                .init(-19, -19), .init( 19, -19), .init( 19, -20), .init(-19, -20)
            ]),
            GKPolygonObstacle(points: [
                .init( 19, -20), .init( 19,  20), .init( 20, -20), .init( 19, -20)
            ]),
            GKPolygonObstacle(points: [
                .init(-19,  19), .init(-19,  20), .init( 19,  20), .init( 19,  19)
            ]),
            GKPolygonObstacle(points: [
                .init(-20, -20), .init(-20,  20), .init(-19,  20), .init(-19, -20)
            ]),
        ]
    }
    /// -20 ~ 20 で探索
    private func _generateObstacles(from level:TSLevel) -> [GKPolygonObstacle] {
        var obstacles = [GKPolygonObstacle]()
    
        for x in -20...20 {
            for z in -20...20 {
                let pos = TSVector3(x, 1, z)
                let block = level.getFillBlock(at: pos)
                if block.isObstacle() {
                    let pos2 = pos.vector2
                    let obs = _createObstacle1x1(at: pos2)
                    
                    fillObstacles[pos2] = obs
                    obstacles.append(obs)
                }
            }
        }
    
        return obstacles // + _generateWalls()
    }

    // TODO: - ブロックサイズに合わせて調整する -
    private func _createObstacle1x1(at point:TSVector2) -> GKPolygonObstacle {
        let p1 = SIMD2<Float>(point.simd)
        let p2 = SIMD2<Float>((point + [1, 0]).simd)
        let p3 = SIMD2<Float>((point + [1, 1]).simd)
        let p4 = SIMD2<Float>((point + [0, 1]).simd)
    
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
    
    private var __getAllSpawnersMemo:[(TSVector2, TSSpawner)]?
    
    private func _getAllSpawners() -> [(TSVector2, TSSpawner)] {
        if let getAllSpawnersMemo = __getAllSpawnersMemo {return getAllSpawnersMemo}
        
        let level = TSLevel.current!
        
        let spawnerBlocks = level.getAllAnchors()
            .map{($0, level.getAnchorBlock(at: $0))}
            .filter { $1 is TS_SpawnerBlock }
            
        let spawnerPositions = spawnerBlocks
            .map{$0.0.vector2}
        
        let spowners = spawnerBlocks
            .map{$1 as! TS_SpawnerBlock}
            .map(TSSpawner.init(block: ))
        
        __getAllSpawnersMemo = zip(spawnerPositions, spowners).map{$0}
     
        return __getAllSpawnersMemo!
    }
    
}
