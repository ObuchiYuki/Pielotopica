//
//  _TPStartScenePlayButton.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// =============================================================== //
// MARK: - _TPStartScenePlayButton -

/**
 */
class _TPStartScenePlayButton:SKSpriteNode {
    // =============================================================== //
    // MARK: - Private Properties -
    private let animator = SKSpriteNode(imageNamed: "TP_startmenu_playbutton_animator")
    private let icon = SKSpriteNode(imageNamed: "TP_startmenu_playbutton_playicon")
    
    // =============================================================== //
    // MARK: - Constructor -
    init() {
        let texture = SKTexture(imageNamed: "TP_startmenu_playbutton_background")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        
        self.addChild(animator)
        self.addChild(icon)
        
        stratAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // =============================================================== //
    // MARK: - Methods -
    func startSpining() {
        self.animator.removeAllActions()
        self.animator.run(.repeatForever(.rotate(byAngle: 3, duration: 0.2)))
    }
    func endSpining() {
        self.animator.removeAllActions()
        stratAnimating()
    }
    // =============================================================== //
    // MARK: - Private Methods -
    
    private func stratAnimating(){
        
        self.animator.run(createRandomRoateteAnimation())
    }
    
    private func createRandomRoateteAnimation() -> SKAction {
        let a1 = SKAction.run {[weak self] in
            self?.animator.run(SKAction.rotate(byAngle: CGFloat.random(in: -3...3), duration: 0.3).setEase(.easeInEaseOut))
        }
        let as1 = SKAction.sequence([a1, .wait(forDuration: 0.3)])
        let as2 = SKAction.repeatForever(as1)
        
        return as2
    }
}
