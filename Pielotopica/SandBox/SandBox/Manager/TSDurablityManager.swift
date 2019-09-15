//
//  TSHardnessManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

class TSDurablityManager {
    // ===================================================================== //
    // MARK: - Properties -
    static let shared = TSDurablityManager()
    
    // [anchorPoint: durablity]
    private var durablityMap =  [TSVector3: Int]()
    // [anchorPoint: TSE_DurablitySprite]
    private var spriteMap = [TSVector3: TSE_DurablitySprite]()
    
    private weak var scene:SCNScene?
    
    // ===================================================================== //
    // MARK: - Methods -
    func connect(scene:SCNScene) {
        self.scene = scene
    }
    
    func getMaxDurablity(at anchorPoint:TSVector3) -> Int{
        return TSTerrainManager.shared.getAnchorBlock(at: anchorPoint).getHardnessLevel()
    }
    
    func getRatio(at anchorPoint:TSVector3) -> Double {
        return getDurablity(at: anchorPoint).d / getMaxDurablity(at: anchorPoint).d
    }
    func getDurablity(at anchorPoint:TSVector3) -> Int {
        let a = durablityMap[anchorPoint] ?? getMaxDurablity(at: anchorPoint)
        
        durablityMap[anchorPoint] = a
            
        return a
    }
    func attack(_ amount:Int, at anchorPoint:TSVector3) {
        if let current = durablityMap[anchorPoint] {
            durablityMap[anchorPoint] = current - amount
        }else{
            durablityMap[anchorPoint] = getMaxDurablity(at: anchorPoint) - amount
        }
        
        check(at: anchorPoint)
    }
    
    // ===================================================================== //
    // MARK: - Private Methods -
    public func _calcSpritePosition(of anchorPoint:TSVector3) -> SCNVector3 {
        let block = TSTerrainManager.shared.getAnchorBlock(at: anchorPoint)
        let size = block.getSize(at: anchorPoint)
        let rotation = TSBlockRotation(data: TSTerrainManager.shared.getBlockData(at: anchorPoint))
        
        return (anchorPoint + rotation.nodeModifier).scnVector3 + SCNVector3(size.x.d / 2, size.y.d , size.z.d / 2)
    }
    
    private func check(at anchorPoint:TSVector3) {
        
        if getDurablity(at: anchorPoint) <= 0 {
            TSTerrainEditor.shared.destoroyBlock(at: anchorPoint)
            
            durablityMap.removeValue(forKey: anchorPoint)
            spriteMap.removeValue(forKey: anchorPoint)
            
        }else{
            if spriteMap[anchorPoint] == nil {
                spriteMap[anchorPoint] = TSE_DurablitySprite(max: getMaxDurablity(at: anchorPoint))
                guard let scene = scene else {return}
                
                spriteMap[anchorPoint]!.show(at: _calcSpritePosition(of: anchorPoint), in: scene)
            }
            let sprite = spriteMap[anchorPoint]!
            
            sprite.durablity = getDurablity(at: anchorPoint)

        }
    }
}
