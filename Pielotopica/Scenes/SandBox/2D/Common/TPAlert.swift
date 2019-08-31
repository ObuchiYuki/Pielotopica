//
//  TSAlert.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPAlertAction {
    let texture: String
    let action: ()->Void
    
    init(texture: String, action: @escaping ()->Void) {
        self.texture = texture
        self.action = action
    }
}

class TPAlert: SKSpriteNode {
    enum Theme {
        case light
        case dark
    }
    
    private let label = SKLabelNode()
    
    private var button1:GKButtonNode!
    private var button2:GKButtonNode!
    
    private var action1 = {}
    private var action2 = {}
    
    func setAction1(_ action:TPAlertAction) {
        action1 = action.action
        button1 = GKButtonNode(
            size: [100, 26], defaultTexture: .init(imageNamed: action.texture),
            selectedTexture: .init(imageNamed: action.texture+"_pressed"),
            disabledTexture: nil
        )
        
        button1.position = [-80, -30]
        button1.addTarget(self, action: #selector(_onButton1(_:)), for: .touchUpInside)
        self.addChild(button1)
        
    }
    func setAction2(_ action:TPAlertAction) {
        action2 = action.action
        button2 = GKButtonNode(
            size: [100, 26], defaultTexture: .init(imageNamed: action.texture),
            selectedTexture: .init(imageNamed: action.texture+"_pressed"),
            disabledTexture: nil
        )
        
        
        button2.position = [ 80, -30]
        button2.addTarget(self, action: #selector(_onButton2(_:)), for: .touchUpInside)
        self.addChild(button2)
    }
    
    init(theme: Theme, text:String) {
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
        
        label.text = text
        label.fontName = TPCommon.FontName.hiraBold
        label.fontSize = 15
        
        self.addChild(label)
        
        self.yScale = 2 / 177
        self.position.x = -400
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func _onButton1(_ sender:Any) {
        action1()
    }
    @objc private func _onButton2(_ sender:Any) {
        action2()
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
        let a = SKAction.sequence([
            SKAction.scaleY(to: 2 / 177, duration: 0.2).setEase(),
            SKAction.wait(forDuration: 0.1),
            SKAction.move(to: [-400, 0], duration: 0.2).setEase(),
        ])
        self.run(a)
    }
}
