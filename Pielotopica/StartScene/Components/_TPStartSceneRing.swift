//
//  _TPStartSceneRing.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// =============================================================== //
// MARK: - _TPStartSceneRing -

/**
 */
class _TPStartSceneRing:GKButtonNode {
    // =============================================================== //
    // MARK: - Private Properties -
    private let playButton = _TPStartScenePlayButton()
    
    private let frameOutside = SKSpriteNode(imageNamed: "TP_startmenu_ring_frame_outside")
    private let frameInside = SKSpriteNode(imageNamed: "TP_startmenu_ring_frame_inside")

    private let animator = SKSpriteNode(imageNamed: "TP_startmenu_ring_animator")
    private let stageImageNode = SKSpriteNode(imageNamed: "TP_stage_level_01")
    // =============================================================== //
    // MARK: - Constructor -
    init() {
        super.init(size: [220, 220])
        
        animator.setScale(0.6)
        
        self.addChild(animator)
        self.addChild(stageImageNode)
        self.addChild(frameInside)
        self.addChild(frameOutside)
        self.addChild(playButton)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =============================================================== //
    // MARK: - Methods -
    private let animationDur = 0.1
    
    override func buttonDidSelect() {
        RMTapticEngine.impact.feedback(.medium)
        
        frameOutside.run(.scale(to: 1.08, duration: animationDur))
        frameInside.run(.scale(to: 0.8, duration: animationDur))
        stageImageNode.run(.scale(to: 0.8, duration: animationDur))
        animator.run(.group([
            .scale(to: 1, duration: animationDur),
            .rotate(byAngle: 0.1, duration: animationDur)
        ]))
        self.playButton.startSpining()
        _startAnimatorAnimation()
    }
    
    override func buttonDidUnselect() {
        frameOutside.run(.scale(to: 1, duration: animationDur))
        frameInside.run(.scale(to: 1, duration: animationDur))
        stageImageNode.run(.scale(to: 1, duration: animationDur))
        animator.run(.sequence([
            .scale(to: 0.6, duration: animationDur),
            .run{[weak self] in self?.animator.removeAllActions()}
        ]))
        self.playButton.endSpining()
    }
    
    private func _startAnimatorAnimation() {
        let a1 = SKAction.run {[weak self] in
            let angle = CGFloat.random(in: -3...3)
            if abs(angle) < 2 {return}
            else {RMTapticEngine.impact.feedback(.medium)}
            self?.animator.run(.rotate(byAngle: angle, duration: 0.3))
        }
        let as1 = SKAction.sequence([a1, .wait(forDuration: 0.3)]).setEase(.easeInEaseOut)
        let as2 = SKAction.repeatForever(as1)
        animator.run(as2)
    }
}
