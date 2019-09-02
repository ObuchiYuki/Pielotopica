//
//  TS_JapaneseHouse.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/28.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSI_JapaneseHouse: TSBlockItem {
    override public func materialsForCraft() -> TSCraftMaterialValue? {
        return TSCraftMaterialValue(iron: 5, wood: 5, circit: 0, fuel: 5)
    }
}
