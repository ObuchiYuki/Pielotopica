//
//  TPFlatButton.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPFlatButton: GKButtonNode {
    
    private let label = SKLabelNode(fontNamed: TPCommon.FontName.pixcel)
    private static let buttonSize:CGSize = [55, 55]
    
    init(defaultTexture :String, selectedTexture: String) {
        super.init(
            size: TPFlatButton.buttonSize,
            defaultTexture: .init(imageNamed: defaultTexture),
            selectedTexture: .init(imageNamed: selectedTexture)
        )
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
