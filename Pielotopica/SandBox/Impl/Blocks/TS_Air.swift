//
//  Air.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/24.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TS_Air: TSBlock {
    override init() {
        super.init()
    }
    override func getSize(at point: TSVector3, at rotation: TSBlockRotation? = nil) -> TSVector3 {
        return .unit
    }
}
