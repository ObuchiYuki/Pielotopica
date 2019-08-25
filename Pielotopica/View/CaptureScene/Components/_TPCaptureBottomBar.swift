//
//  _TPCaptureBottomBar.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/25.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit


class _TPCaptureBottomBar: GKSpriteNode {
    let backButton = TPFlatButton(textureNamed: "TP_flatbutton_back")
    
    let placeButton = TPDropButton(textureNamed: "TP_dropbutton_place")
    let moveButton = TPDropButton(textureNamed: "TP_dropbutton_move")
    let destoryButton = TPDropButton(textureNamed: "TP_dropbutton_destory")
    
    private var allDropButtons:[SKSpriteNode] {
        return [placeButton, moveButton, destoryButton]
    }
    
    func show() {
        isHidden = false
        
        allDropButtons.enumerated().forEach{(arg) in
            let (i, e) = arg
            e.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.1 * Double(i) + 0.3),
                SKAction.scale(to: 1, duration: 0.2).setEase(.easeInEaseOut)
            ]))
        }
    }
    
    func hide() {
        allDropButtons.enumerated().forEach{(arg) in
            let (i, e) = arg
            e.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.1 * Double(i)),
                SKAction.scale(to: 0, duration: 0.2).setEase(.easeInEaseOut)
            ]))
        }
    }
    
    init() {
        super.init(texture: nil, color: .clear, size: [312, 47])
        
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
        
        placeButton.position = [CGFloat(312 - 47 - 60 * 2 + 47.0/2), CGFloat(47.0/2)]
        placeButton.isUserInteractionEnabled = true
        
        moveButton.position = [CGFloat(312 - 47 - 60 + 47.0/2), CGFloat(47.0/2)]
        moveButton.isUserInteractionEnabled = true
        
        destoryButton.position = [CGFloat(312 - 47 + 47.0/2), CGFloat(47.0/2)]
        destoryButton.isUserInteractionEnabled = true
                
        placeButton.setScale(0)
        moveButton.setScale(0)
        destoryButton.setScale(0)
        
        addChild(backButton)
        addChild(placeButton)
        addChild(moveButton)
        addChild(destoryButton)
    }
}
