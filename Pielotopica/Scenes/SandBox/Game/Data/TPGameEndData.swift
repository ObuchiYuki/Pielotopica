//
//  TPGameEndData.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/01.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
 
public struct TPGameEndData {
    public enum State {
        case gameover
        case clear
        case interruption
    }
    
    public var state:State
    public var award:TPClearAward
}
