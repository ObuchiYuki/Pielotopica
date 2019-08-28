//
//  TPCraftMoreItems.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/27.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPCraftMoreItems: SKSpriteNode {
    // ==================================================================== //
    // MARK: - Properties -
    override var needsHandleReaction: Bool { true }
    
    private let selectionFrame = GKSpriteNode(imageNamed: "TP_build_itembar_selection_frame")

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: touch.view)
        
        touchX(location)

    }
    
    // ==================================================================== //
    // MARK: - Private Methods -
    private func _moveSelectionFrame(x:Int, y:Int) {
        
    }
    
    private func _frameTouched(x:Int, y:Int) {
        
    }
    
    private func touchX(_ location:CGPoint) {
        switch location.x {
        case 40...110:
            touchY(x: 0, y: location.y)
        case 100...170:
            touchY(x: 1, y: location.y)
        case 170...240:
            touchY(x: 2, y: location.y)
        case 240...310:
            touchY(x: 3, y: location.y)
        case 310...380:
            touchY(x: 4, y: location.y)
            
        default: break
        }
    }
    
    private func touchY(x:Int, y:CGFloat) {
        switch y {
        case 440...510:
            _frameTouched(x: x, y: 0)
        case 510...580:
            _frameTouched(x: x, y: 1)
        case 580...650:
            _frameTouched(x: x, y: 2)
        default: break
        }
    }
    
    // ==================================================================== //
    // MARK: - Constructor -
    init() {
        super.init(texture: .init(imageNamed: "TP_craft_moreitems_background"), color: .clear, size: [314, 198])
        
        self.zPosition = 100
        
        self.addChild(selectionFrame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
