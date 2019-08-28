//
//  TPMainMenu.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/21.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

/// Position -> settted
class TPMainMenu: SKSpriteNode {
    
    let menuItem = TPMainMenuItem(textureNamed: "TP_mm_menu")
    let buildItem = TPMainMenuItem(textureNamed: "TP_mm_build")
    let captureItem = TPMainMenuItem(textureNamed: "TP_mm_capture")
    let shopItem = TPMainMenuItem(textureNamed: "TP_mm_shop")
    
    private var allItems:[SKSpriteNode] {
        return [menuItem, buildItem, captureItem, shopItem]
    }
    func hide() {
        allItems.enumerated().forEach{i, e in e.run(_hideAction(at: i))}
    }
    
    func show() {
        allItems.enumerated().forEach{i, e in e.run(_showAction(at: i))}
    }
    
    init() {
        super.init(texture: nil, color: .clear, size: [328, 76])
        
        allItems.enumerated().forEach{i, e in _setupItem(item: e, index: i)}
        
        self.position = CGPoint(
            x: -GKSafeScene.sceneSize.width/2 + 23,
            y: -GKSafeScene.sceneSize.height/2 + 16
        )
        
        show()
        
    }
    
    
    private func _setupItem(item:SKSpriteNode, index:Int) {
        item.position = [CGFloat((76+8) * index), -180]
        
        addChild(item)
        
    }
    
    private func _hideAction(at index:Int) -> SKAction {
        return SKAction.sequence([
            SKAction.wait(forDuration: Double(allItems.count - index - 1) * 0.1),
            SKAction.moveTo(y: -180, duration: 0.3).setEase(.easeInEaseOut)
        ])
    }
    private func _showAction(at index: Int) -> SKAction {
        return SKAction.sequence([
            SKAction.wait(forDuration: Double(index) * 0.1),
            SKAction.moveTo(y: 0, duration: 0.3).setEase(.easeInEaseOut)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
