//
//  TPStartBackgroundScene.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/06.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// =============================================================== //
// MARK: - TPStartBackgroundScene -

/**
 */
class TPStartBackgroundScene:SKScene {
    // =============================================================== //
    // MARK: - Properties -
    let rootNode = SKSpriteNode(imageNamed: "TP_startmenu_background")
    
    let overray = _TPStartSceneOverray()
    // =============================================================== //
    // MARK: - Private Properties -
    
    // =============================================================== //
    // MARK: - Methods -
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        addChild(rootNode)
        rootNode.zPosition = -1001
        
        rootNode.size = GKSafeScene.sceneSize
        rootNode.position = GKSafeScene.sceneSize.point / 2
        
        overray.position = GKSafeScene.sceneSize.point / 2
        
        let filePath = Bundle.main.path(forResource: "TPStartSceneBackgroundParticle", ofType: "sks")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let emitterNode = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! SKEmitterNode
        emitterNode.resetSimulation()
        emitterNode.zPosition = -1000
        emitterNode.position = [GKSafeScene.sceneSize.width/2 ,GKSafeScene.sceneSize.height]
        
        self.addChild(emitterNode)
        self.addChild(overray)
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
}
