//
//  TSData.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/25.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

public struct TSLevelData: Codable {
    public var fillMap:[[[UInt16]]]
    public var anchorBlockMap:[[[UInt16]]]
    public var blockDataMap:[[[UInt8]]]
    public var anchorSet:[TSVector3]

    func save(stageNamed name:String) {
        RMStorage.shared.store(self, for: ._levelDataKey(for: name))
    }
    init() {
        fillMap =
            Array(repeating: Array(repeating: Array(repeating: 0, count: kLevelMaxZ), count: kLevelMaxY), count: kLevelMaxX)
        anchorBlockMap =
            Array(repeating: Array(repeating: Array(repeating: 0, count: kLevelMaxZ), count: kLevelMaxY), count: kLevelMaxX)
        blockDataMap =
            Array(repeating: Array(repeating: Array(repeating: 0, count: kLevelMaxZ), count: kLevelMaxY), count: kLevelMaxX)
        
        anchorSet = []
    }
    
    init(fillMap: [[[UInt16]]], anchorBlockMap: [[[UInt16]]], blockDataMap: [[[UInt8]]], anchorSet: [TSVector3]) {
        self.fillMap = fillMap
        self.anchorBlockMap = anchorBlockMap
        self.blockDataMap = blockDataMap
        self.anchorSet = anchorSet
    }
    static func load(stageNamed name:String) -> TSLevelData {
        if let data = RMStorage.shared.get(for: ._levelDataKey(for: name)) {
            return data
        }else{
            return TSLevelData()
        }
    }
}

extension RMStorage.Key {
    fileprivate static func _levelDataKey(for stageName:String) -> RMStorage.Key<TSLevelData> {
        return .init(rawValue: "_"+stageName+"_stringValueKey")
        
    }
}
