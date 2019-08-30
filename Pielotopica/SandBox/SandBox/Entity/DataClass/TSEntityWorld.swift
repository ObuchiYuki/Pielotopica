//
//  TSEntityWorld.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

protocol TSEntityWorldDelegate: class {
    func addNode(_ node: SCNNode)
}

/// 動的オブジェクトが入る場所です。
class TSEntityWorld {
    // ================================================================== //
    // MARK: - Properties -
    
    /// この世界に存在するエンティティ
    var entities = [TSEntityObject]()
    private weak var delegate:TSEntityWorldDelegate!
    
    // ================================================================== //
    // MARK: - Private Properties -
    private var spawners = [TSVector2: TSSpawner]()
    private var counter = 0
    private var updateInterval = 0.5
    private var timer:Timer? = nil
    
    // ================================================================== //
    // MARK: - Methods -
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: {[weak self] timer in
            guard let self = self else { return timer.invalidate() }
            self._update()
            self._spawnUpdate()
            
        })
        _getAllSpawners().forEach{spawners[$0] = $1}
    }
    
    func end() {
        self.entities.forEach{ $0.removeFromWorld() }
        self.entities = []
        self.timer?.invalidate()
        self.spawners = [:]
    }
    
    
    func removeObject(_ object:TSEntityObject) {
        guard let index = entities.firstIndex(where: {$0 === object}) else {return print("Not found")}
        entities.remove(at: index)
    }
    
    // ================================================================== //
    // MARK: - Construcotr -
    
    init(delegate:TSEntityWorldDelegate) {
        self.delegate = delegate
    }

    
    // ================================================================== //
    // MARK: - Private Methods -
    
    private func _update() {
        for entity in entities  {
            entity.entity.update(tic: updateInterval, object: entity, world: self, level: TSLevel.current)
        }
    }
    
    private func _spawnUpdate() {
        // 1秒に2回呼ばれる
        counter += 1
        
        for (point, spawner) in spawners {
            /// 一回呼ばれるのに何1/2秒かかるか
            let t = Int((1.0 / spawner.frequency.d) * 100 / updateInterval)
            
            if counter % t == 0 {
                let obj = TSEntityObject(world: self, initialPosition: point, entity: spawner.entity, node: spawner.entity.generateNode())
                
                entities.append(obj)
                delegate.addNode(obj.node)
            }
        }
    }
    
    private func _getAllSpawners() -> [(TSVector2, TSSpawner)] {
        let level = TSLevel.current!
        
        let spawnerBlocks = level.getAllAnchors()
            .map{($0, level.getAnchorBlock(at: $0))}
            .filter { $1 is TS_SpawnerBlock }
            
        let spawnerPositions = spawnerBlocks
            .map{$0.0.vector2}
        
        let spawners = spawnerBlocks
            .map{$1 as! TS_SpawnerBlock}
            .map(TSSpawner.init(block: ))
     
        return zip(spawnerPositions, spawners).map{$0}
    }
    
}
