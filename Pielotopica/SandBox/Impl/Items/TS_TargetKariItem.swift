//
//  TS_TargetKariItem.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/30.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TS_TargetKariItem: TSBlockItem {
    override public func materialsForCraft() -> TSCraftMaterialValue? {
        return TSCraftMaterialValue(iron: 0, wood: 0, circit: 0, fuel: 0)
    }
}
