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
    static var shared:TSMaterialData {get {autosave.value} set {autosave.value = newValue}}
    
    var ironAmount =   BehaviorRelay(value: 0)
    var woodAmount =   BehaviorRelay(value: 0)
    var circitAmount = BehaviorRelay(value: 0)
    
    mutating func setIron(_ amount:Int) {
        ironAmount.accept(amount)
    }
    mutating func setWood(_ amount:Int) {
        woodAmount.accept(amount)
    }
    mutating func setCircit(_ amount:Int) {
        circitAmount.accept(amount)
    }
}


