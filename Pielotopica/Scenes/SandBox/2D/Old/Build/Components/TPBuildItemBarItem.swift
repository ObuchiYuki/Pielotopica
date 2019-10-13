//
//  TPBuildItemBarItem.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/22.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxSwift
import RxCocoa
import SpriteKit

class TPBuildItemBarItem: SKSpriteNode {
    
    let iconNode = SKSpriteNode()
    let numLabel = GKShadowLabelNode()
    
    private let bag = DisposeBag()
    
    func setItemStack(_ itemStack:TSItemStack, needShowWhenNone:Bool) {
        iconNode.texture = itemStack.item.itemImage.map{SKTexture.init(image: $0)}
        
        itemStack.count.subscribe{[unowned self] event in
            guard let num = event.element else {return}
            self.numLabel.text = "x \(num)"
            
            if num == 0 {
                self.numLabel.alpha = 0
                self.iconNode.alpha = 0
            }else{
                self.numLabel.alpha = 1
                self.iconNode.alpha = 1
            }
            
            if needShowWhenNone && num == 0 {
                self.numLabel.alpha = 0.5
                self.iconNode.alpha = 0.5
            }
            
            
        
        }.disposed(by: bag)
    }

    init() {
        super.init(texture: nil, color: .clear, size: [58, 58])
        
        iconNode.size = [50, 50]
        iconNode.color = .clear
        
        numLabel.position = [23, -20]
        numLabel.fontName = TPCommon.FontName.topica
        numLabel.fontColor = .white
        numLabel.fontSize = 15
        numLabel.horizontalAlignmentMode = .right
        
        numLabel.barnShadow()
        
        self.addChild(iconNode)
        self.addChild(numLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
