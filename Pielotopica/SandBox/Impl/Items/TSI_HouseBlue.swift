//
//  TSI_HouseBlue.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSI_HouseBlue: TSBlockItem {
    override public func materialsForCraft() -> TSCraftMaterialValue? {
        return TSCraftMaterialValue(iron: 5, wood: 15, circit: 0, fuel: 15)
    }
}
