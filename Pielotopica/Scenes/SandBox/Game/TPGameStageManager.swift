//
//  TPGameStageManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

struct TPStageData {
    /// 秒数
    let time:Int
}

class TPGameStageManager {
    static let shared = TPGameStageManager()
    
    private var day = 1
    
    private var dataList = [
        TPStageData(time: 120),
        TPStageData(time: 120),
        TPStageData(time: 120),
        TPStageData(time: 120),
        TPStageData(time: 120),
        TPStageData(time: 120),
        TPStageData(time: 120)
    ]
    
    func getDay() -> Int {
        return day
    }
    func timeAmount(on day:Int) -> Int {
        return dataList[day].time
    }
}
