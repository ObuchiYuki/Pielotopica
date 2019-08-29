//
//  TPCraftMoreItems.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/27.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit
import RxSwift
import RxCocoa

/**
 (0, 0), (1, 0), (2, 0), (3, 0), (4, 0)
 (0, 1), (1, 1), (2, 1), (3, 1), (4, 1)
 (0, 2), (1, 2), (2, 2), (3, 2), (4, 2)
 */
class TPCraftMoreItems: SKSpriteNode {
    // ==================================================================== //
    // MARK: - Properties -
        
    static let showingItems = TSItemManager.shared.getCreatableItems()
    
    override var needsHandleReaction: Bool { true }
    
    let selectedItemIndex = BehaviorRelay(value: 0)
    let items = TSItemManager.shared.getCreatableItems()
    
    // ==================================================================== //
    // MARK: - Private Properties -
    private let selectionFrame = GKSpriteNode(imageNamed: "TP_build_itembar_selection_frame")
    private var itemNodes = [TPBuildItemBarItem]()

    // ==================================================================== //
    // MARK: - Methods -
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: touch.view)
        
        touchX(location)

    }
    
    // ==================================================================== //
    // MARK: - Private Methods -
    private func _loadItem() {
        for (i, item) in TPCraftMoreItems.showingItems.enumerated() {
            guard let itemStack = TSInventory.shared.itemStacks.value.first(where: {$0.item == item}) else {return}
            let itemNode = itemNodes[i]
            
            itemNode.setItemStack(itemStack)
        }
    }
    private func _setupItems(){
        for y in 0..<3 {
            for x in 0..<5 {
                let item = TPBuildItemBarItem()
                item.position = [(CGFloat(x) * 57.5) - 115, CGFloat(3 - y) * 57.5 - 115]
                itemNodes.append(item)
                self.addChild(item)
            }
        }
    }
    private func _moveSelectionFrame(x:Int, y:Int) {
        let ry = 3 - y
        selectionFrame.position = [(CGFloat(x) * 57.5) - 149, CGFloat(ry) * 57.5 - 150]
    }
    
    private func _frameTouched(x:Int, y:Int) {
        TPButtonReaction()
        
        selectedItemIndex.accept(x + y * 5)
        _moveSelectionFrame(x: x, y: y)
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
        self.position = [0, -80]
        
        self.addChild(selectionFrame)
        
        _setupItems()
        _loadItem()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
