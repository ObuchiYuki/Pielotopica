//
//  _TPStartScenePatterns.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// =============================================================== //
// MARK: - _TPStartScenePatters -

/**
 */
class _TPStartScenePatterns: SKSpriteNode {
    // =============================================================== //
    // MARK: - Private Properties -
    
    private let actionIndicator = _TPStartSceneActionIndicator(action: "Tap to start")
    
    private let patternTop = SKSpriteNode(imageNamed: "TP_startmenu_pattern_top")
    private let patternBottom = SKSpriteNode(imageNamed: "TP_startmenu_pattern_bottom")
    private let patternLeft = SKSpriteNode(imageNamed: "TP_startmenu_pattern_left")
    private let patternRight = SKSpriteNode(imageNamed: "TP_startmenu_pattern_right")
    
    // =============================================================== //
    // MARK: - Methods -
    
    // =============================================================== //
    // MARK: - Constructor -
    init() {
        super.init(texture: nil, color: .clear, size: [310, 300])
        
        _setupPatterns()
        _setupActionIndicator()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // =============================================================== //
    // MARK: - Private Methods -
    private func _setupActionIndicator() {
        actionIndicator.position.y = 175
        
        self.addChild(actionIndicator)
    }
    
    private func _setupPatterns() {
        patternTop.position.y = 140
        patternBottom.position.y = -140
        
        patternRight.position.x = 150
        patternLeft.position.x = -150
        
        self.addChild(patternLeft)
        self.addChild(patternBottom)
        self.addChild(patternRight)
        self.addChild(patternTop)
        
        self._startAnimating()
    }
    
    private func _startAnimating() {
        let a1 = SKAction.sequence([
            SKAction.moveBy(x: -10, y: 0, duration: 1).setEase(.easeInEaseOut),
            SKAction.moveBy(x: 10, y: 0, duration: 1).setEase(.easeInEaseOut)
        ])
        
        patternLeft.run(.repeatForever(a1))
        
        let a2 = SKAction.sequence([
            SKAction.moveBy(x: 10, y: 0, duration: 1).setEase(.easeInEaseOut),
            SKAction.moveBy(x: -10, y: 0, duration: 1).setEase(.easeInEaseOut)
        ])
        
        patternRight.run(.repeatForever(a2))
    }
}
