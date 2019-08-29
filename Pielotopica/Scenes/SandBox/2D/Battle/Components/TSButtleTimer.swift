//
//  File.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/29.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TSBattleTimer: SKSpriteNode {
    let timerFrame = SKSpriteNode(imageNamed: "TP_buttle_timer_frame")
    let selected = SKSpriteNode(color: .init(hex: 0xFFC836), size: [0, 4])
    
    /// 0-4
    func setTime(_ time:Double) {
        assert(0 <= time && time <= 4, "time must be between 0 and 4.")
        let rwidth = time / 4 * 214
        
        selected.run(.resize(toWidth: rwidth.f, duration: 0.1))
    }
    
    init() {
        super.init(texture: nil, color: .clear, size: [251, 20])
        
        self.position = [-32, 260]
        selected.anchorPoint = [0, 0.5]
        selected.position = [-CGFloat(251) / 2, 0]
        
        self.addChild(timerFrame)
        self.addChild(selected)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
