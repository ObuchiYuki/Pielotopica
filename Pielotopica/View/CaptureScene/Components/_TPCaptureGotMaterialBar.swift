//
//  _TPCaptureGotMaterialBar.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/26.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class _TPCaptureGotMaterialBar: SKCropNode {
    // ============================================================== //
    // MARK: - Properties -
    
    // nodes
    private let background = SKSpriteNode(texture: .init(imageNamed: "TP_cap_getitem_background"), color: .clear, size: [343, 78])
    
    private let nameLabel = SKLabelNode(fontNamed: TPCommon.FontName.topica)
    
    private let ironSprite = _TPCaptureMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_iron")
    private let woodSprite = _TPCaptureMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_wood")
    private let circitSprite = _TPCaptureMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_circit")
    private let heartSprite = _TPCaptureMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_heart")
    private let fuelSprite = _TPCaptureMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_fuel")
    
    private var allSprites:[SKSpriteNode] {
        [ironSprite, woodSprite, circitSprite, heartSprite, fuelSprite]
    }
    
    // ============================================================== //
    // MARK: - Methods -
    
    func loadValue(objectNamed name:String, _ value: TSMaterialValue) {
        var showTypes = [MaterialType]()
        
        nameLabel.run(.typewriter(name, withPerDuration: 0.05))
        
        if value.iron != 0   { showTypes.append(.iron(value.iron)) }
        if value.wood != 0   { showTypes.append(.wood(value.wood)) }
        if value.circit != 0 { showTypes.append(.circit(value.circit)) }
        if value.heart != 0  { showTypes.append(.heart(value.heart)) }
        if value.fuel != 0   { showTypes.append(.fuel(value.fuel)) }
        
        assert(showTypes.count < 4, "Value has more then 3 item to show...?")
        
        _showSprites(with: showTypes)
    }
    
    // ============================================================== //
    // MARK: - Constructor -
    
    override init() {
        super.init()
        self.position = [0, 180]
        self.maskNode = SKSpriteNode(color: .black, size: [343, 78])

        self.addChild(background)
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = [-130, 3]
        nameLabel.fontSize = 16
        nameLabel.fontColor = TPCommon.Color.text
        
        self.addChild(nameLabel)
        
        _setupSprites()
    }
    
    private func _setupSprites() {
        for sprite in allSprites {
            sprite.position = [-300, -12]

            self.addChild(sprite)
        }
    }
    
    // ============================================================== //
    // MARK: - Private Methods -
    
    enum MaterialType { case iron(Int), wood(Int), circit(Int), heart(Int), fuel(Int) }
    
    private func _count(for type:MaterialType) -> Int {
        switch type {
        case .iron(let count): return count
        case .wood(let count): return count
        case .circit(let count): return count
        case .heart(let count): return count
        case .fuel(let count): return count
        }
    }
    private func _sprite(for type:MaterialType) -> _TPCaptureMaterialSprite {
        switch type {
        case .iron:   return ironSprite
        case .wood:   return woodSprite
        case .circit: return circitSprite
        case .heart:  return heartSprite
        case .fuel:   return fuelSprite
        }
    }
    
    private var showingTypes = [MaterialType]()
    
    private func _hideSprites() {
        nameLabel.text = ""
        for type in showingTypes {
            let sprite = _sprite(for: type)
            
            sprite.run(SKAction.moveTo(x: 250, duration: 0.2).setEase(.easeInEaseOut))
        }
    }
    
    private func _showSprites(with types: [MaterialType] ) {
        showingTypes = []
        
        for sprite in allSprites {
            sprite.removeAllActions()
            sprite.position = [-300, -12]
        }
        
        for type in types {
            
            showingTypes.append(type)
            
            let offset = -180 + showingTypes.count * (78 + 10)
            
            let sprite = _sprite(for: type)
            let count  = _count(for: type)
            sprite.setCount(count)

            sprite.run(SKAction.sequence([
                SKAction.moveTo(x: CGFloat(offset), duration: 0.2).setEase(.easeInEaseOut),
                SKAction.wait(forDuration: 2),
                SKAction.run{ self._hideSprites() },
            ]))
        }
    }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
