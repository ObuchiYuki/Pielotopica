//
//  TSItemManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/25.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa
import RxSwift
 
struct TSMaterialData: RMAutoSavable {
    private static var _shared = RMAutoSave<TSMaterialData>("TSMaterialData__key")
    
    static var shared:TSMaterialData {get {_shared.value ?? TSMaterialData()} set {_shared.value = newValue}}
    
    static func reset() {
        _shared.reset()
    }
    
    var ironAmount =   BehaviorRelay(value: 0)
    var woodAmount =   BehaviorRelay(value: 0)
    var circitAmount = BehaviorRelay(value: 0)
    
    mutating func addIron(_ amount:Int) {
        ironAmount += amount
    }
    mutating func addWood(_ amount:Int) {
        woodAmount += amount
    }
    mutating func addCircit(_ amount:Int) {
        circitAmount += amount
    }
}


