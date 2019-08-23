//
//  TPBuildSideMenu.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/23.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit

class TPBuildSideMenu: GKSpriteNode {
    enum ShowMode {
        case place
        case move
        case destory
    }
    let rotateItem = TPBuildSideMenuItem(imageNamed: "TP_build_button_rotate")
    
    init() {
        super.init(texture: nil, color: .red, size: [94, 200])
        
        rotateItem.position = [-100 , 0]
        
        self.addChild(rotateItem)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(as mode:ShowMode) {
        switch mode {
        case .place:
            rotateItem.run(SKAction.moveTo(x: 47, duration: 0.3).setEase(.easeInEaseOut))
        default: break
        }
    }
    func hide() {
        rotateItem.run(SKAction.moveTo(x: -100, duration: 0.3).setEase(.easeInEaseOut))
    }
}
