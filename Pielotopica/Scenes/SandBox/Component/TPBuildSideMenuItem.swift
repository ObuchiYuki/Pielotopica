//
//  TPBuildSideMenuItem.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/23.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPBuildSideMenuItem: GKButtonNode {
    init(imageNamed name:String) {
        super.init(
            size: [94, 47],
            defaultTexture: .init(imageNamed: name),
            selectedTexture: .init(imageNamed: name+"_pressed"),
            disabledTexture: nil
        )
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buttonDidUnselect() {
        TPButtonReaction()
    }
}
