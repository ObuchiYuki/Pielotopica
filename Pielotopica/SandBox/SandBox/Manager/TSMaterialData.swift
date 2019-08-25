//
//  TSItemManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/25.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import RxCocoa

private let _autosave = RMAutoSave<TSMaterialData>("TSItemManagersData")
 
struct TSMaterialData: RMAutoSavable {
    static var shared: TSMaterialData { get {_autosave.value} set {_autosave.value = newValue} }
        
    var ironAmount = BehaviorRelay(value: 0)
    var woodAmount = BehaviorRelay(value: 0)
    var circitAmount = BehaviorRelay(value: 0)
}


