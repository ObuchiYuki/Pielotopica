//
//  TSFileSaveManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

protocol TSOccasionSavable {
    var isEdited: Bool { get set }
}

public class TSFileSaveManager {
    public static let shared = TSFileSaveManager()
    
    
}
