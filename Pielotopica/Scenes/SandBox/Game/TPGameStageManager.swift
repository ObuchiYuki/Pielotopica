//
//  TPGameStageManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

class TPGameStageManager {
    static let shared = TPGameStageManager()
    
    private var day = 1
    
    private func _createStage1(_ level: TSLevel) {
        
    }
    
    private lazy var dataList = [
        TPStageData(
            time: 120,
            award: .init(iron: 120, wood: 120, circit: 10, fuel: 200, score: 12919),
            updateLevel: {[weak self] in self?._createStage1($0)}
        ),
    ]
    
    func getDay() -> Int {
        return day
    }
    func timeAmount(on day:Int) -> Int {
        return dataList[day - 1].time
    }
    func award(on day:Int) -> TPClearAward {
        dataList[day - 1].award
    }
}
