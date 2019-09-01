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
    
    private var dataList = [
        TPStageData(time: 120, award: .init(iron: 120, wood: 120, circit: 10, fuel: 200, score: 12919)),
        TPStageData(time: 120, award: .init(iron: 200, wood: 150, circit: 10, fuel: 300, score: 12424)),
        TPStageData(time: 120, award: .init(iron: 200, wood: 150, circit: 10, fuel: 300, score: 12424))
    ]
    
    func getDay() -> Int {
        return day
    }
    func timeAmount(on day:Int) -> Int {
        return dataList[day].time
    }
}
