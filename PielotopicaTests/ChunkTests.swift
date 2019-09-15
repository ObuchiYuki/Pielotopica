//
//  ChunkTests.swift
//  PielotopicaTests
//
//  Created by yuki on 2019/09/15.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation

import XCTest
@testable import Pielotopica

func _calcurateChunkPosition(from globalPoint: TSVector3) -> TSVector3 {
    let position = globalPoint - _calcurateChunkPoint(from: globalPoint.vector2).vector3(y: 0)
    
    assert(!position.hasNegative, "ChunkPosition must not have negative component.")
    
    return position
}

func _calcurateChunkPoint(from pointContaining: TSVector2) -> TSChunkPoint {
    
    return TSChunkPoint(pointContaining.x16 / TSChunk.sideWidth, pointContaining.z16 / TSChunk.sideWidth)
}


class ChunkTests: XCTestCase {
    func testCalcurateChunkPosition() {
        
    }
}
