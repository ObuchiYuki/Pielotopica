//
//  PielotopicaTests.swift
//  PielotopicaTests
//
//  Created by yuki on 2019/08/23.
//  Copyright © 2019 yuki. All rights reserved.
//

import XCTest
@testable import Pielotopica

class TSVector3Test: XCTestCase {

    func testValues() {
        for i in 0..<80 {
            XCTAssertEqual(i, TSMaterialValueMap.getValue(for: i).classIndex) 
        }

    }
    func testAdd() {
        let cases:[(TSVector3, TSVector3, TSVector3)] = [
            (TSVector3(10, 10, 10), TSVector3(10, 10, 10), TSVector3(20, 20, 20)),
            (TSVector3(12, 1, 1),   TSVector3(12, 4,  55), TSVector3(24, 5,  56))
        ]
        
        for sample in cases {
            XCTAssertEqual(sample.0 + sample.1, sample.2)
        }
    }
    
    func testRotate() {
        let cases:[(TSVector3, TSVector3)] = [
            (TSVector3(1, 2, 3).rotated(y: 1), TSVector3(-3, 2, 1)),
            (TSVector3(1, 2, 3).rotated(y: 2), TSVector3(-1, 2, -3)),
            (TSVector3(1, 2, 3).rotated(y: 3), TSVector3(3, 2, -1))
            ]
                
        for sample in cases {
            XCTAssertEqual(sample.0, sample.1)
        }
    }
}
