//
//  TSTerrainEditor.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// MARK: - TSTerrainEditor -

public class TSTerrainEditor {
    // MARK: - Singleton -
    public static let shared = TSChunkEditor()
    
    // MARK: - Methods -
    
    @discardableResult
    public func placeBlock(_ block:TSBlock, at anchor:TSVector3, rotation:TSBlockRotation, forced:Bool = false) -> Bool {
        
    }
    
    @discardableResult
    public func destoryBlock(at anchor: TSVector3) -> Bool {
        return true
    }
    
    // MARK: - Privates -
    
    private func _placeAnchor(_ block: TSBlock, anchor:TSVector3) {
        TSChunkManager.shared
    }
}
