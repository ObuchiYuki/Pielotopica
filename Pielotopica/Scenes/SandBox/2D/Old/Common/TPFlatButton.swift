//
//  TPFlatButton.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

// ======================================================== //
// MARK: - TPFlatButton -
class TPFlatButton: GKButtonNode {
    
    // ======================================================== //
    // MARK: - Properties -
    private static let buttonSize:CGSize = [55, 55]
    
    private let _title:String
    private let _label = SKLabelNode(fontNamed: TPCommon.FontName.pixcelBold)
    
    // ======================================================== //
    // MARK: - Constructor -
    
    private func _setup() {
        
        _label.text = _title
        _label.fontSize = 10
        _label.fontColor = TPCommon.Color.text
        _label.position = [0, -20]
        
        self.addChild(_label)
    }
    
    init(defaultTexture :String, selectedTexture: String, label: String) {
        _title = label
        
        super.init(
            size: TPFlatButton.buttonSize,
            defaultTexture: .init(imageNamed: defaultTexture),
            selectedTexture: .init(imageNamed: selectedTexture)
        )
        
        _setup()
        
    }
    
    required init(coder: NSCoder) { fatalError() }
}
