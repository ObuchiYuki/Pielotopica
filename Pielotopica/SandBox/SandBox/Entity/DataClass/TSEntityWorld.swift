//
//  TSEntityWorld.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

/// 動的オブジェクトが入る場所です。
class TSEntityWorld {
    // ================================================================== //
    // MARK: - Properties -
    
    /// この世界に存在するエンティティ
    var entities = [TSVector2: (TSEntity, SCNNode)]()
    
    /// シングルトン
    static let shared = TSEntityWorld()
    
    // ================================================================== //
    // MARK: - Private Properties -
    private var spawners = [TSSpawner]()
    private var counter = 0
    private var timer:Timer? = nil
    
    // ================================================================== //
    // MARK: - Methods -
    func start() {
        self.timer = _genTimer()
        self.timer?.fire()
        self.spawners = _getAllSpawners()
    }
    func stop() {
        self.timer?.invalidate()
        self.spawners = []
    }
    
    // ================================================================== //
    // MARK: - Private Methods -
    private func _update() {
        for (entity, node) in zip(entities, nodes)  {
            entity.update(node: node, world: self, level: TSLevel.current)
        }
    }
    
    
    private func _spawnUpdate() {
        // 1秒に2回呼ばれる
        counter += 1
        
        for spawner in spawners {
            /// 一回呼ばれるのに何秒かかるか
            let t = Int((1.0 / spawner.frequency.d) * 100)
            
            if counter % t == 0 {
                entities.append(spawner.entity)
                nodes.append(spawner.entity.generateNode())
            }
        }
    }
    
    private func _getAllSpawners() -> [TSSpawner] {
        let level = TSLevel.current!
        let spawners = level.getAllAnchors()
            .map(level.getAnchorBlock)
            .filter{$0 is TSSpawnerBlock}
            .map{$0 as! TSSpawnerBlock}
            .map(TSSpawner.init(block: ))
     
        return spawners
    }
    private func _genTimer() -> Timer {
        return Timer(timeInterval: 0.5, repeats: true, block: {[weak self] timer in
            guard let self = self else { return timer.invalidate() }
            self._update()
            self._spawnUpdate()
        })
    }
    
}
