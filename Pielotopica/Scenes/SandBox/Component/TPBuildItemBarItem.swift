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
    
    func setItemStack(_ itemStack:TSItemStack) {
        iconNode.texture = itemStack.item.itemImage.map{SKTexture.init(image: $0)}
        itemStack.count.subscribe{[weak self] event in
            guard let num = event.element else {return}
            if num == 0 {
                self?.numLabel.text = ""
            }else{
                self?.numLabel.text = "x \(num)"
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
        numLabel.text = "x 118"
        
        numLabel.barnShadow()
        
        self.addChild(iconNode)
        self.addChild(numLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
