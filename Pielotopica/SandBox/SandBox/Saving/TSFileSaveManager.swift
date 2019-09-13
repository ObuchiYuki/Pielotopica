//
//  TSFileSaveManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// MARK: - TSOccasionSavable -
public protocol TSOccasionSavable: Codable {
    var isEdited: Bool { get set }
    var savePerTick: UInt { get }
}


// MARK: - TSFileSaveManager -

public class TSFileSaveManager {
    public static let shared = TSFileSaveManager()
    
    // MARK: - Privates -
    private var savable = RMWeakSet<TSOccasionSavable>()
    
    // MARK: - Methods -
    /// 弱参照
    public func register(_ clazz: TSOccasionSavable) {
        savable.append(clazz)
    }
    
    public func initirize() {
        
    }
}
