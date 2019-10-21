//
//  TPBadgeButton.swift
//  Pielotopica
//
//  Created by yuki on 2019/10/21.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// MARK: - Constants -
private let kTPBadgeButtonSize: CGSize = [55, 55]
private let kTPBadgeButtonAnimationDur:TimeInterval = 0.08
private let kTPBadgeButtonTargetScaleIn:CGFloat = 0.95
private let kTPBadgeButtonTargetScaleOut:CGFloat = 1.1


class TPBadgeButton: GKButtonNode {
    // ==================================================== //
    // MARK: - Properties -
    
    // MARK: - Nodes -
    private let _iconNode:SKSpriteNode
    private let _ringOut = SKSpriteNode(imageNamed: "TP_badgebutton_ring_out")
    private let _ringIn  = SKSpriteNode(imageNamed: "TP_badgebutton_ring_in")
    
    // ==================================================== //
    // MARK: - Methods -
    
    override func buttonDidUnselect() {
        super.buttonDidUnselect()
        
        _ringOut.run(.scale(to: 1, duration: kTPBadgeButtonAnimationDur))
        _ringIn.run(.scale(to: 1, duration: kTPBadgeButtonAnimationDur))
    }
    
    override func buttonDidSelect() {
        
        // Animete
        _ringOut.run(SKAction.scale(
            to: kTPBadgeButtonTargetScaleOut,
            duration: kTPBadgeButtonAnimationDur
        ))
        
        _ringIn.run(SKAction.scale(
            to: kTPBadgeButtonTargetScaleIn,
            duration: kTPBadgeButtonAnimationDur
        ))
        
        RMTapticEngine.impact.feedback(.light)
    }
    
    // ==================================================== //
    // MARK: - Construcotrs -
    
    init(iconNamed iconName: String) {
        self._iconNode = SKSpriteNode(imageNamed: iconName)
        
        super.init(
            size: kTPBadgeButtonSize,
            defaultTexture: nil,
            selectedTexture: nil,
            disabledTexture: nil
        )
        
        self.addChild(_ringOut)
        self.addChild(_ringIn)
        self.addChild(_iconNode)
    }
    
    required init(coder: NSCoder) { fatalError("Never") }
}
