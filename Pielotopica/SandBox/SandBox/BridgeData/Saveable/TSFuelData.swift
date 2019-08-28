//
//  TSFuelData.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/26.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa

struct TSFuelData: RMAutoSavable {
    private static var _shared = RMAutoSave<TSFuelData>("TSFuelData__key")
    static var shared:TSFuelData {get {_shared.value ?? TSFuelData()} set {_shared.value = newValue}}
    
    var heart = BehaviorRelay(value: 0)
    var maxHeart = BehaviorRelay(value: 100)
    
    var fuel = BehaviorRelay(value: 0)
    var maxFuel = BehaviorRelay(value: 100)
    
    mutating func addHeart(_ amount:Int) {
        heart += amount
    }
    mutating func setMaxHeart(_ amount:Int) {
        maxHeart.accept(amount)
    }
    mutating func addFuel(_ amount:Int) {
        fuel += amount
    }
    mutating func setMaxFuel(_ amount:Int) {
        maxFuel.accept(amount)
    }
}
