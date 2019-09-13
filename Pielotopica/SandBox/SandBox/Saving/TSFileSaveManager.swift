//
//  TSFileSaveManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public protocol TSOccasionSavable: Codable {
    var isEdited: Bool { get set }
    var savePerTick: UInt { get }
}

public class TSFileSaveManager {
    public static let shared = TSFileSaveManager()
    
    
    
}
