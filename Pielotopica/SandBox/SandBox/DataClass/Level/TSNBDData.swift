//
//  TSNBDManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TSNBDManager {
    static let shared = TSNBDManager()
    
    private var loadedDataMap = [TSVector3: TSNBD]()
    
    /// 自動書き込みなので安心して ❤️
    func getNBD(at point:TSVector3) -> TSNBD {
        if let data = loadedDataMap[point] {return data}
        
        return TSNBD(point: point)
    }
}
