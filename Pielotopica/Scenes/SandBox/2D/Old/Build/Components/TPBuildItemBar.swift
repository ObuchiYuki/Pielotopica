//
//  TPBuildItemBar.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxSwift
import RxCocoa
import SpriteKit

class TPBuildItemBar: SKSpriteNode {
    // ============================================================ //
    // MARK: - Nodes -
    
    // MARK: - Buttons -
    let backButton = TPFlatButton(textureNamed: "TP_flatbutton_back")
    
    let placeButton = TPDropButton(textureNamed: "TP_dropbutton_place")
    let moveButton = TPDropButton(textureNamed: "TP_dropbutton_move")
    let destoryButton = TPDropButton(textureNamed: "TP_dropbutton_destory")
    
    // MARK: - Frame -
    private let selectionFrame:SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "TP_build_itembar_selection_frame")
        node.anchorPoint = .zero
        return node
    }()
    
    let moreButton = GKButtonNode(
        size: [55, 55],
        defaultTexture: .init(imageNamed: "TP_build_itembar_morebutton"),
        selectedTexture: .init(imageNamed: "TP_build_itembar_morebutton_pressed"),
        disabledTexture: nil
    )
    
    private let allBarItems = [
        TPBuildItemBarItem(), TPBuildItemBarItem(),
        TPBuildItemBarItem(), TPBuildItemBarItem(),
    ]
    
    var allDropButtons:[TPDropButton] {
        return [placeButton, moveButton, destoryButton]
    }
    
    // ============================================================ //
    // MARK: - Properties -
    
    private let bag = DisposeBag()
    private let inventory:TSItemBarInventory
    override var needsHandleReaction: Bool { return true }
    
    // ============================================================ //
    // MARK: - methods -
    func show(animated:Bool,  _ completion: (()->Void)? = nil) {
        if animated{
            let a = SKAction.sequence([
                SKAction.moveTo(y: -340, duration: 0.3).setEase(.easeInEaseOut),
                SKAction.run{completion?()}
            ])
            self.run(a)
        }else{
            isHidden = false
            self.position.y = -340
            completion?()
        }
    }
    func showDrops(animated:Bool,  _ completion: (()->Void)? = nil) {
        if animated {
            allDropButtons.enumerated().forEach{(arg) in
                let (i, e) = arg
                e.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.1 * Double(i) + 0.3),
                    SKAction.scale(to: 1, duration: 0.2).setEase(.easeInEaseOut),
                    SKAction.run{ if i == 3 { completion?() } }
                ]))
            }
        }else{
            allDropButtons.forEach{$0.setScale(1)}
            completion?()
        }
    }
    
    func hideDrops(animated:Bool, _ completion: (()->Void)? = nil) {
        if animated {
            allDropButtons.enumerated().forEach{(arg) in
                let (i, e) = arg
                e.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.1 * Double(i)),
                    SKAction.scale(to: 0, duration: 0.2).setEase(.easeInEaseOut),
                    SKAction.run{ if i == 3 { completion?() } }
                ]))
            }
        }else{
            allDropButtons.forEach{$0.setScale(0)}
            completion?()
        }
    }
    
    func hide(animated:Bool, _ completion:(()->Void)? = nil) {
        if animated {
            self.run(
                SKAction.sequence([
                    SKAction.wait(forDuration: 0.3),
                    SKAction.moveTo(y: -570, duration: 0.3).setEase(.easeInEaseOut),
                    SKAction.run {[weak self] in self?.isHidden = true ; completion?()}
                ])
            )
        }else{
            self.isHidden = true
            completion?()
        }
    }
    
    // ============================================================ //
    // MARK: - Override Methods -
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        
        guard 14 < location.y && location.y < 80 else {return}
        
        _frameSelected(at: Int(location.x - 10) / 60)
    }
    
    // ============================================================ //
    // MARK: - Constructor -
    init(inventory:TSItemBarInventory) {
        self.inventory = inventory
                
        super.init(texture: .init(imageNamed: "TP_build_itembar_frame"), color: .clear, size: [312, 80])
        
        self.anchorPoint = .zero
        self.zPosition = 100
        self.position = [-GKSafeScene.sceneSize.width / 2 + 30, -570]
        
        _setupButtons()
        _setupInventoryNodes()
        _setupBarItems()
    }
    
    // ============================================================ //
    // MARK: - Private Methods -
    private func _frameSelected(at index:Int) {
        guard 0 <= index && index <= 3 else {return}
        
        inventory.setSelectedItemIndex(index)
        
        TPBuildNotice.show(text: inventory.selectedItemStack.item.name)
    }
    
    private func _setupInventoryNodes() {
        selectionFrame.position.y = 8
        
        self.addChild(selectionFrame)
        
        
        self.inventory.selectedItemIndex.bind{[weak self] e in
            self?.moveFrame(to: e)
        }.disposed(by: bag)
        
        self.inventory.itemStacks.bind{[weak self] itemStack in
            guard let self = self else {return}
            
            for (i, baritem) in self.allBarItems.enumerated() {
                baritem.setItemStack(itemStack[i], needShowWhenNone: false)
            }
        }.disposed(by: bag)
    }
    
    private func _setupBarItems() {
        allBarItems.enumerated().forEach{(i, e) in
            e.position = [CGFloat(41 + 57.5 * Double(i)) , 41]
            
            self.addChild(e)
        }
    }
    
    private func moveFrame(to index:Int) {
        RMTapticEngine.impact.feedback(.light)
        selectionFrame.position.x = 8 + 57.5 * CGFloat(index)
    }
    
    private func _setupButtons() {
        backButton.position = [0, 95]
        
        placeButton.position = [CGFloat(312 - 47 - 60 * 2 + 47.0/2), CGFloat(95 + 47.0/2)]
        moveButton.position = [CGFloat(312 - 47 - 60 + 47.0/2), CGFloat(95 + 47.0/2)]
        destoryButton.position = [CGFloat(312 - 47 + 47.0/2), CGFloat(95 + 47.0/2)]
        
        moreButton.zPosition = 100
        moreButton.position = [271, 39]
        

        placeButton.setScale(0)
        moveButton.setScale(0)
        destoryButton.setScale(0)
        
        addChild(backButton)
        addChild(placeButton)
        addChild(moveButton)
        addChild(destoryButton)
        addChild(moreButton)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
