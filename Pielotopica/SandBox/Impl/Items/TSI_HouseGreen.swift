//
//  TSI_HouseGreen.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSI_HouseGreen: TSBlockItem {
    override public func materialsForCraft() -> TSCraftMaterialValue? {
        return TSCraftMaterialValue(iron: 10, wood: 30, circit: 1, fuel: 30)
    }
}
