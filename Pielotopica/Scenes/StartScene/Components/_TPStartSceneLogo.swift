//
//  _TPStartSceneLogo.swift
//  TPStartScene
//
//  Created by yuki on 2019/07/07.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class _TPStartSceneLogo: SKSpriteNode {
    // =============================================================== //
    // MARK: - Properties -
    
    let logoLabel = SKLabelNode(fontNamed: TPCommon.FontName.logo)
    let logoShadowLabel = SKLabelNode(fontNamed: TPCommon.FontName.logo)
    
    // =============================================================== //
    // MARK: - Constructor -
    init() {
        super.init(texture: .init(imageNamed: "TP_startmenu_logo_background"), color: .clear, size: [306, 97])
        
        setupLogoLabel()
        startLogoAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =============================================================== //
    // MARK: - Private Mathods -
    
    private func setupLogoLabel() {
        logoLabel.position.y = -14
        logoShadowLabel.position = [2, -16]
        
        addChild(logoShadowLabel)
        addChild(logoLabel)
    }
    private func startLogoAnimation() {
        self.logoLabel.run(createLogoAnimation())
    }
    
    private func createLogoAnimation() -> SKAction {
        var acs = [SKAction.wait(forDuration: 0.4)]

        for i in 1..."Pielotopica".count {
            RMTapticEngine.impact.prepare(.medium)
            
            acs.append(.run{[i] in
                RMTapticEngine.impact.feedback(.medium)
                let r = NSRange(location: 0, length: i)
                
                self.logoLabel.attributedText =
                    TPCommon.AttributeText.logo.attributedSubstring(from: r)
                self.logoShadowLabel.attributedText =
                    TPCommon.AttributeText.logoShadow.attributedSubstring(from: r)
                
            })
            acs.append(.wait(forDuration: 0.1))
            
        }
        return SKAction.sequence(acs)
    }
}
