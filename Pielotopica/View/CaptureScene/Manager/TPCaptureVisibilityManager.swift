//
//  TPCaptureVisibilityManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TPCaptureVisibilityManager {
    
    static let shared = TPCaptureVisibilityManager()
    
    // visibilityMap[ClassIndex] = Visibility
    private var visibilityMap = TPMaterialValueMap.needsShowMap
    
    func isVisible(classIndex:Int) -> Bool {
        return visibilityMap[classIndex]
    }
    
    func setVisibility(_ visibility: Bool, for classIndex: Int) {
        visibilityMap[classIndex] = visibility
    }
}
