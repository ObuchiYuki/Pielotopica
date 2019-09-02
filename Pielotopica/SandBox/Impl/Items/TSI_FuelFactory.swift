//
//  TSI_FuelFactory.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSI_FuelFactory: TSBlockItem {
    
    override public func materialsForCraft() -> TSCraftMaterialValue? {
        return TSCraftMaterialValue(iron: 10, wood: 10, circit: 0, fuel: 10)
    }
}

