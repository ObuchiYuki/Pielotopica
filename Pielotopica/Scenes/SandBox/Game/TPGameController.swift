//
//  TPGameController.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import SceneKit


class TPGameController {
    
    // ===================================================================== //
    // MARK: - Properties -
    public static weak var initirized: TPGameController?
    
    private let scene:SCNScene
    private var level:TSLevel {TSLevel.current!}
    
    /// 敵の目的地
    private lazy var entityWorld = TSEntityWorld(delegate: self)
    
    private var stageManager:TPGameStageManager {TPGameStageManager.shared}
    
    private var updateTimer:Timer?
    private var battleSceneModel:TPSBattleSceneModel? {TPSandBoxRootSceneModel.shared.currentSceneModel as? TPSBattleSceneModel}
    
    private var maxTime = 120
    private var timeRemain = 0
    
    // ===================================================================== //
    // MARK: - Methods -
    
    func start() {
        maxTime = stageManager.timeAmount(on: stageManager.getDay())
        timeRemain = stageManager.timeAmount(on: stageManager.getDay())
        
        self._update()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] timer in
            guard let self = self else {return timer.invalidate()}
            
            self._update()
        })
        
        level.delegates.append(self)
        TSDurablityManager.shared.connect(scene: scene)
        self.entityWorld.start()
                
    }
    func end(with state: TPGameEndData.State) {
        self.entityWorld.end()
        
        let award = stageManager.award(on: stageManager.getDay())
        
        print("END with state: \(state)")
        
        RMBindCenter.default.post(name: .TPGameControllerGameDidEnd, object: TPGameEndData(state: state, award: award))
    }
    
    // ===================================================================== //
    // MARK: - Private -
    
    // 毎秒呼ばれる。
    private func _update() {
        self.timeRemain -= 1
        
        if self.timeRemain <= 0 {
            self.end(with: .clear)
        }
        
        guard let battleSceneModel = battleSceneModel else { return }
        
        battleSceneModel.setTime(timeRemain, max: maxTime)
    }
    
    // ===================================================================== //
    // MARK: - Constructor -
    init(scene: SCNScene) {
        self.scene = scene
        
        TPGameController.initirized = self
    }
}

extension TPGameController: TSLevelDelegate {
    func level(_ level: TSLevel, levelDidUpdateBlockAt position: TSVector3, needsAnimation: Bool, withRotation: TSBlockRotation) {
        entityWorld.onPlaceObject(at: position)
    }

    
    func level(_ level: TSLevel, levelWillDestoryBlockAt position: TSVector3) {
        entityWorld.onDestoryObject(at: position)
    }
}

extension TPGameController: TSEntityWorldDelegate {
    func addNode(_ node: SCNNode) {
        self.scene.rootNode.addChildNode(node)
    }
}

extension RMBinder.Name where Object == TPGameEndData {
    static let TPGameControllerGameDidEnd = RMBinder.Name(rawValue: "__TPGameControllerGameDidEnd__")
}
