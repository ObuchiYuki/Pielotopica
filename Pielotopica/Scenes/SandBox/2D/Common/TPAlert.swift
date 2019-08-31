//
//  TSAlert.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPAlert: SKSpriteNode {
    enum Theme {
        case light
        case dark
    }
    
    private let label = SKLabelNode()
    private let button1:GKButtonNode
    private let button2:GKButtonNode
    
    private let action1: ()->Void
    private let action2: ()->Void
    
    init(theme: Theme, text:String, button1t:String, button2t:String, action1: @escaping ()->Void, action2: @escaping ()->Void ) {
        self.action1 = action1
        self.action2 = action2
        
        button1 = GKButtonNode(
            size: [100, 26], defaultTexture: .init(imageNamed: button1t),
            selectedTexture: .init(imageNamed: button1t+"_pressed"),
            disabledTexture: nil
        )
        
        button2 = GKButtonNode(
            size: [100, 26], defaultTexture: .init(imageNamed: button2t),
            selectedTexture: .init(imageNamed: button2t+"_pressed"),
            disabledTexture: nil
        )
        
        if theme == .light {
            super.init(texture: .init(imageNamed: "TP_alert_light_background"), color: .clear, size: [375, 177])
        }else{
            super.init(texture: .init(imageNamed: "TP_alert_dark_background"), color: .clear, size: [375, 177])
        }
        
        if theme == .light {
            label.color = TPCommon.Color.text
        }else{
            label.color = TPCommon.Color.card
        }
        
        button1.position = [-80, -30]
        
        button2.position = [ 80, -30]
        self.addChild(button1)
        self.addChild(button2)
        
        label.text = text
        label.fontName = TPCommon.FontName.hiraBold
        label.fontSize = 15
        
        self.addChild(label)
        
        self.yScale = CGFloat(2) / 177
        self.position.x = -400
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        
        
        let a = SKAction.sequence([
            SKAction.move(to: .zero, duration: 0.2).setEase(),
            SKAction.wait(forDuration: 0.1),
            SKAction.scaleY(to: 1, duration: 0.2).setEase()
        ])
        self.run(a)
    }
    
    func hide() {
        
    }
}
