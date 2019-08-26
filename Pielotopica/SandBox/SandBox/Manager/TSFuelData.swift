//
//  TSFuelData.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/26.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa

struct TSFuelData: RMAutoSavable {
    static var shared:TSFuelData {get {autosave.value} set {autosave.value = newValue}}
    
    var heart = BehaviorRelay(value: 0)
    var maxHeart = BehaviorRelay(value: 0)
    
    var fuel = BehaviorRelay(value: 0)
    var maxFuel = BehaviorRelay(value: 0)
    
    mutating func setHeart(_ amount:Int) {
        heart.accept(amount)
    }
    mutating func setMaxHeart(_ amount:Int) {
        maxHeart.accept(amount)
    }
    mutating func setFuel(_ amount:Int) {
        fuel.accept(amount)
    }
    mutating func setMaxFuel(_ amount:Int) {
        maxFuel.accept(amount)
    }
}
