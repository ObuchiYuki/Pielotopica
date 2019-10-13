//
//  _TPCaptureBottomBar.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/25.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit


class _TPCaptureBottomBar: SKSpriteNode {
    let backButton = TPFlatButton(textureNamed: "TP_flatbutton_back")
    
    let infoButton = GKButtonNode(
        size: [130, 36],
        defaultTexture:  .init(imageNamed: "TP_capture_info"),
        selectedTexture: .init(imageNamed: "TP_capture_info_pressed"),
        disabledTexture: nil
    )
    
    func show() {
        isHidden = false
        
        infoButton.run(SKAction.scale(to: 1, duration: 0.2).setEase())
    }
    
    func hide() {
        infoButton.run(SKAction.scale(to: 0, duration: 0.2).setEase())
    }
    
    init() {
        super.init(texture: nil, color: .clear, size: [312, 47])
        
        self.anchorPoint = .zero
        self.position = [-GKSafeScene.sceneSize.width / 2 + 31, -300]
        
        _setupButtons()
        
        show()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupButtons() {
        backButton.position = [0, 0]
        backButton.isUserInteractionEnabled = true
        
        infoButton.position = [CGFloat(250), CGFloat(47.0/2 - 3)]
        infoButton.isUserInteractionEnabled = true
                
        infoButton.setScale(0)
        
        addChild(backButton)
        addChild(infoButton)
        
    }
}
