//
//  TSI_IronWall.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSI_IronWall: TSBlockItem {
    override public func materialsForCraft() -> TSCraftMaterialValue? {
        return TSCraftMaterialValue(iron: 30, wood: 5, circit: 0, fuel: 20)
    }
}
