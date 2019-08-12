//
//  _TPStartSceneTabItem.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// =============================================================== //
// MARK: - _TPStartSceneTabItem -

class _TPStartSceneTabItem:GKButtonNode {
    // =============================================================== //
    // MARK: - Properties -
    
    private let animationDur = 0.7
    private let title:String
    
    // =============================== //
    // MARK: - Nodes -
    private let iconNode:SKSpriteNode
    private let titleLabel:SKLabelNode
    
    private let outsideFrame = SKSpriteNode(imageNamed: "TP_startmenu_tabitem_frame_outside")
    private let insideFrame = SKSpriteNode(imageNamed: "TP_startmenu_tabitem_frame_inside")
    
    private let titleDotRight = SKSpriteNode(color: TPCommon.Color.icon, size: [5, 5])
    private let titleDotLeft = SKSpriteNode(color: TPCommon.Color.icon, size: [5, 5])
    
    // =============================================================== //
    // MARK: - Constructor -
    
    init(iconImageNamed name:String, title:String) {
        self.iconNode = SKSpriteNode(imageNamed: name)
        self.titleLabel = SKLabelNode(fontNamed: TPCommon.FontName.topica)
        self.title = title
        
        super.init(size: [66, 76])
        
        setupIconNode()
        setupTitleLabel()
        setupDots()
        setupFrame()
        
        startAnimating()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =============================================================== //
    // MARK: - Methods -
    private let _animationDuration = 0.1
    
    override func buttonDidSelect() {
        RMTapticEngine.impact.feedback(.medium)
        
        insideFrame.run(
            .scale(to: 0.95, duration: _animationDuration)
        )
        outsideFrame.run(
            .scale(to: 1.1, duration: _animationDuration)
        )
    }
    override func buttonDidUnselect() {
        insideFrame.run(
            .scale(to: 1, duration: _animationDuration)
        )
        outsideFrame.run(
            .scale(to: 1, duration: _animationDuration)
        )
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    private func setupFrame() {
        insideFrame.position.y = -25
        outsideFrame.position.y = -25
        
        addChild(insideFrame)
        addChild(outsideFrame)
    }
    private func startAnimating() {
        titleDotLeft.position = [0 ,-72]
        titleDotRight.position = [0 ,-72]
        
        titleDotLeft.run(
            SKAction.move(to: [30 ,-72], duration: animationDur)
        )
        
        titleDotRight.run(
            SKAction.move(to: [-30 ,-72], duration: animationDur)
        )
        startTitleAnimating()
    }
    private func startTitleAnimating() {
        
        
        titleLabel.run(SKAction.typewriter(title, withDuration: 0.7))
    }
    private func setupDots() {
        
        addChild(titleDotLeft)
        addChild(titleDotRight)
    }
    private func setupTitleLabel() {
        titleLabel.fontSize = 13
        titleLabel.position = [0, -77]
        titleLabel.fontColor = TPCommon.Color.text
        
        addChild(titleLabel)
    }
    private func setupIconNode() {
        iconNode.position = [0, -25]
        
        addChild(iconNode)
    }
}
