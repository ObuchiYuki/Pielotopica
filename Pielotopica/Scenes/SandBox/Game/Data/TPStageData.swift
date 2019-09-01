//
//  TPStageData.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation


struct TPStageData {
    /// 秒数
    let time:Int
    let award:TPClearAward
    let updateLevel: (TSLevel)->()
}
