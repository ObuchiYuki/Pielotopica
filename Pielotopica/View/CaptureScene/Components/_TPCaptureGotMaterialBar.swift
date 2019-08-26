//
//  _TPCaptureGotMaterialBar.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/26.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class _TPCaptureGotMaterialBar: SKCropNode {
    let background = SKSpriteNode(texture: .init(imageNamed: "TP_cap_getitem_background"), color: .clear, size: [343, 78])
    
    let nameLabel = SKLabelNode()
    
    let ironSprite = _TPCaptureMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_iron")
    let woodSprite = _TPCaptureMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_wood")
    let circitSprite = _TPCaptureMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_circit")
    let heartSprite = _TPCaptureMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_heart")
    let fuelSprite = _TPCaptureMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_fuel")
    
    override init() {
        super.init()
        position = [0, 180]
        self.maskNode = SKSpriteNode(color: .black, size: [343, 78])
        
        self.addChild(background)
        
        self.addChild(ironSprite)
        self.addChild(woodSprite)
        self.addChild(circitSprite)
        self.addChild(heartSprite)
        self.addChild(fuelSprite)
    }
    
    func loadValue(_ value: TSMaterialValue) {
        var showTypes = [MaterialType]()
        
        if value.iron != 0 { showTypes.append(.iron) }
        if value.wood != 0 { showTypes.append(.wood) }
        if value.circit != 0 { showTypes.append(.circit) }
        if value.heart != 0 { showTypes.append(.heart) }
        if value.fuel != 0 { showTypes.append(.fuel) }
        
        assert(showTypes.count < 4, "Value has more then 3 item to show...?")
        
        _showSprites(with: showTypes)
    }
    
    enum MaterialType { case iron, wood, circit, heart, fuel }
    
    private func _sprite(for type:MaterialType) -> _TPCaptureMaterialSprite {
        switch type {
        case .iron:   return ironSprite
        case .wood:   return woodSprite
        case .circit: return circitSprite
        case .heart:  return heartSprite
        case .fuel:   return fuelSprite
        }
    }
    
    private func _showSprites(with types: [MaterialType] ) {
        for type in types {
            _showSprite(for: type)
        }
    }
    
    private var showingTypes = [MaterialType]()
    
    private func _showSprite(for type:MaterialType) {
        showingTypes.append(type)
        
        var offset = 20 + showingTypes.count * (78 + 10)
        
        let sprite = _sprite(for: type)

        sprite.run(.move(to: [CGFloat(offset), 0], duration: 0.4))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
