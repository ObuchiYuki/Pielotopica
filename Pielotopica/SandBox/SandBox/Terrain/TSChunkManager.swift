//
//  TSChunkManager.swift
//  Pielotopica
//
//  Created by yuki on 2019/09/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation


class TSChunkManager {
    static let shared = TSChunkManager()

    func chunk(at point: TSChunkPoint) -> TSChunk {
        if let saved = TSChunkFileLoader.shared.loadChunk(at: point) {
            return saved
        }
    }
}
