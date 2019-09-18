//
//  TSE_DebugSprite.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/17.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

#if DEBUG
class TSE_DebugSprite: TSSprite {
    static var initirizedList = [TSE_DebugSprite]()
    
    private let sprite = DebugSprite()
    
    static func show(at point: TSVector3, with text: String) {
        guard let scene = GKGameViewController._debug?.scnView.scene else {return}
        
        let se = TSE_DebugSprite(text: text)
        se.show(at: point.scnVector3, in: scene)
    }
    
    public var text:String? {
        get {sprite.label.text}
        set {sprite.label.text = newValue}
    }
    
    init(text: String) {
        super.init(sprite: sprite)
        TSE_DebugSprite.initirizedList.append(self)
        
        self.sprite.label.text = text
    }
}

private class DebugSprite: SKSpriteNode {
    let label = SKLabelNode()
    
    init() {
        super.init(texture: nil, color: .purple, size: [100, 30])
        
        label.fontSize = 16
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        
        label.fontColor = .white
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
