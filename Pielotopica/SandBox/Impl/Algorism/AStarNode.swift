//
//  AStarNode.swift
//  Pielotopica
//
//  Created by yuki on 2019/08/31.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation


/// Astarで使用するノードデータ
public class Node {
    /// ノードのポジション
    var nodeId:TSVector2

    /// このノードにたどり着く前のノードポジション
    var fromNodeId:TSVector2!

    /// 経路として使用できないフラグ
    var isLock:Bool
    
    /// ノードの有無
    var isActive:Bool

    /// 必要コスト
    var moveCost:Double

    /// ヒューリスティックなコスト
    var _heuristicCost:Double

    /// 空のノードの生成
    static func createBlankNode(_ position: TSVector2) -> Node {
        return Node(position, TSVector2(-1, -1))
    }

    /// ノード生成
    static func createNode(_ position: TSVector2, _ goalPosition: TSVector2) -> Node {
        return Node(position, goalPosition);
    }

    /// CreateBlankNode,CreateNodeを使用してください
    init(_ nodeId: TSVector2,_ goalNodeId: TSVector2) {
        self.nodeId = nodeId
        self.isLock = false
        self.moveCost = 0
        self.isActive = false
        self._heuristicCost = 0 // (仮)
        
        self.updateGoalNodeId(goalNodeId)
    }

    /// ゴール更新 ヒューリスティックコストの更新
    func updateGoalNodeId(_ goal: TSVector2) {
        // 直線距離をヒューリスティックコストとする
        let dx = goal.x - nodeId.x
        let dz = goal.z - nodeId.z
        
        self._heuristicCost = sqrt(Double(dx * dx + dz * dz))
    }

    func getScore() -> Double {
        return moveCost + _heuristicCost
    }

    func setFromNodeId(_ value:TSVector2) {
        fromNodeId = value;
    }

    func remove() {
        isActive = false
    }

    func add() {
        isActive = true
    }

    func setMoveCost(_ cost:Double) {
        moveCost = cost
    }

    func setIsLock(_ isLock:Bool) {
        self.isLock = isLock
    }

    func clear() {
        remove()
        moveCost = 0;
        updateGoalNodeId(TSVector2(-1, -1));
    }
}
