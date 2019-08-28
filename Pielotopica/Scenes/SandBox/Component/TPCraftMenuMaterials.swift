//
//  TPCraftMenuMaterials.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPCraftMenuMaterials:SKSpriteNode {
    private let ironSprite = TPMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_iron")
    private let woodSprite = TPMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_wood")
    private let circitSprite = TPMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_circit")
    private let fuelSprite = TPMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_fuel")
    
    private var allSprites:[TPMaterialSprite] { [ironSprite, woodSprite, circitSprite, fuelSprite] }
    
    func show(value: TSCraftMaterialValue) {
        for sprite in allSprites {
            sprite.isHidden = true
        }
        
        var sprites = [(Int, Int, TPMaterialSprite)]()
        let data = TSMaterialData.shared
        
        if value.iron != 0 {
            sprites.append((value.iron, data.ironAmount.value, ironSprite))
        }
        if value.wood != 0 {
            sprites.append((value.wood, data.woodAmount.value, woodSprite))
        }
        if value.circit != 0 {
            sprites.append((value.circit,data.circitAmount.value, circitSprite))
        }
        if value.fuel != 0 {
            sprites.append((value.fuel, TSFuelData.shared.fuel.value, fuelSprite))
        }
        
        assert(sprites.count < 4)
        
        for (i, (c, a, sprite)) in sprites.enumerated() {
            sprite.isHidden = false
            sprite.position = [0,30 - CGFloat(30 * i)]
            sprite.setCount(c)
            sprite.setLabelColor(c > a ? TPCommon.Color.dangerous : TPCommon.Color.text)
        }
    }
    
    func hide() {
        allSprites.forEach{$0.isHidden = true}
    }
    
    init() {
        super.init(texture: nil, color: .clear, size: [80, 80])
        
        for sprite in allSprites {
            sprite.isHidden = true
            
            self.addChild(sprite)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
