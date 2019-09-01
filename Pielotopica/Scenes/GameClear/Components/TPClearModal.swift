//
//  TPClearModal.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPClearModal: SKSpriteNode {
    init() {
        super.init(texture: .init(imageNamed: "TP_clear_modal_bacground"), color: .clear, size: [308, 418])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
