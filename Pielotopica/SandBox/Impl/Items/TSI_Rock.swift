//
//  TSI_Rock.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/02.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public class TSI_Rock: TSBlockItem {
    public override func visibleOnlyWhileDebug() -> Bool {
        return  true
    }
    override public func materialsForCraft() -> TSCraftMaterialValue? {
        return TSCraftMaterialValue(iron: 0, wood: 0, circit: 0, fuel: 5)
    }
}
