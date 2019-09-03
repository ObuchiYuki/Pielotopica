//
//  TPSettingSlider.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/03.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa
import SpriteKit

class TPSettingSlider: SKSpriteNode {
    var value = BehaviorRelay(value: Float(0))
    
    private let handle = SKSpriteNode(color: TPCommon.Color.icon, size: [10, 30])
    private let titleLabel = SKLabelNode(fontNamed: TPCommon.FontName.topica)
    private let frameNode = SKSpriteNode(imageNamed: "TP_setting_slider")
    
    override var needsHandleReaction: Bool {true}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touche = touches.first else {return}
        let point = touche.location(in: self)
        
        handle.position.x = point.x
        
        value.accept(340 / Float(point.x))
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touche = touches.first else {return}
        let point = touche.location(in: self)
        
        handle.position.x = point.x
        
        value.accept(340 / Float(point.x))
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touche = touches.first else {return}
        let point = touche.location(in: self)
        
        handle.position.x = point.x
        
        value.accept(340 / Float(point.x))
    }
    
    init(title:String, volume: Float) {
        value.accept(volume)
        super.init(texture: nil, color: .clear, size: [340, 60])
        
        isUserInteractionEnabled = true
        
        titleLabel.position = [-170, 30]
        titleLabel.fontColor = TPCommon.Color.text
        titleLabel.fontSize = 23
        titleLabel.horizontalAlignmentMode = .left
        titleLabel.run(.typewriter(title, withDuration: 0.7))
        
        
        self.addChild(titleLabel)
        self.addChild(frameNode)
        
        frameNode.addChild(handle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
