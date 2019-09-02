//
//  TPBuildSideMenu.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/23.
//  Copyright © 2019 yuki. All rights reserved.
//

import SpriteKit



class TPBuildSideMenu: GKSpriteNode {

    let rotateItem = TPBuildSideMenuItem(imageNamed: "TP_build_button_rotate")
    
    init() {
        super.init(texture: nil, color: .clear, size: [94, 200])
        
        self.position = [-170, -300]
        rotateItem.position = [-100 , 175]
        
        self.addChild(rotateItem)
        
        hide()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(as mode: TPSBuildSceneModel.Mode) {
        switch mode {
        case .place, .move:
            rotateItem.run(SKAction.moveTo(x: 47, duration: 0.3).setEase(.easeInEaseOut))
        default: hide()
        }
    }
    func hide() {
        rotateItem.run(SKAction.moveTo(x: -100, duration: 0.3).setEase(.easeInEaseOut))
    }
}
