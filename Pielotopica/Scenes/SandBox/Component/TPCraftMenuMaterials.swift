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
    private let heartSprite = TPMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_heart")
    private let fuelSprite = TPMaterialSprite(textureNamed: "TP_cap_gotitem_sprite_fuel")
    
    init() {
        super.init(texture: nil, color: .clear, size: [])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
