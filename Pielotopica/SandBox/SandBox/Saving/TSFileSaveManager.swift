//
//  TSFileSaveManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

// MARK: - TSOccasionSavable -
public protocol TSTickBasedSavable {
    /// Whether it has been edited since the last save
    var isEdited: Bool { get set }
    
    /// The ticks per a saving.
    var tickPerSave: UInt { get }
    
    /// Implemention of saving.
    func save()
}

// MARK: - TSFileSaveManager -

public class TSFileSaveManager {
    public static let shared = TSFileSaveManager()
    
    // MARK: - Privates -
    private var savables = RMWeakSet<TSTickBasedSavable>()
    
    // MARK: - Methods -
    /// 弱参照
    public func register(_ clazz: TSTickBasedSavable) {
        savables.append(clazz)
    }
    
    public func initirize() {
        TSEventLoop.shared.register(self)
    }
}

extension TSFileSaveManager: TSEventLoopDelegate {
    public func update(_ eventLoop: TSEventLoop, at tick: TSTick) {
        for savable in savables {
            if tick.value % savable.tickPerSave == 0 {
                savable.save()
            }
        }
    }
}
 
