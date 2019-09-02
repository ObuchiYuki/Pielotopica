//
//  TS_House.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import UIKit

class TS_House: TSBlock {
    
    // =============================================================== //
    // MARK: - Properties -
    
    public let color:HouseColor
    
    // =============================================================== //
    // MARK: - Methods -
    
    enum HouseColor {
        case red
        case green
        case blue
    }
    
    init(color: HouseColor, nodeNamed nodeName: String, index: Int) {
        
        self.color = color
        
        super.init(nodeNamed: nodeName, index: index)
    }
    
    override func createNode() -> SCNNode {
        let node = super.createNode()
        
        let image:UIImage
        
        switch color {
        case .green: image = UIImage(named: "TP_house_green")!
        case .blue:  image = UIImage(named: "TP_house_blue")!
        case .red:   image = UIImage(named: "TP_house_red")!
        }
        
        node.fmaterial?.diffuse.contents = image
        
        return node
    }
    
    override func getOriginalNodeSize() -> TSVector3 {
        return [2, 2, 2]
    }
    override func getHardnessLevel() -> Int {
        return 20
    }
    override func isObstacle() -> Bool {
        return true
    }
    override func canDestroy(at point: TSVector3) -> Bool {
        return true
    }
    override func shouldAnimateWhenPlaced(at point: TSVector3) -> Bool {
        return true
    }
}


