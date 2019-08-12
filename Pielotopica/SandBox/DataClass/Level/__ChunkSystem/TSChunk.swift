/// 一時的にチャンクシステムは凍結中
/*//
//  TSChunk.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/12.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit

// =============================================================== //
// MARK: - Const -
private let kChankMaxX = 20
private let kChankMaxY = 256
private let kChankMaxZ = 20

public protocol TSChunkDelegate :class{
    func chunk(_ chunk:TSChunk, didBlockUpdatedAt position: TSVector3)
}

// =============================================================== //
// MARK: - TSChunk -
/**
 処理を分割するために、（20、256、20の範囲に限定した地形です。）
 */
public final class TSChunk {
    // =============================================================== //
    // MARK: - Properties -
    
    public weak var delegate:TSChunkDelegate?
    
    /// チャンクのポジションです。サンドボックス座標系とは 1:10 の関係となります。
    public let chunkPosition:TSVector2
    
    /// チャンクのサンドボックス座標です。
    public var sandboxPosition:TSVector3 {
        return chunkPosition.vector3 * 10
    }
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    /// フィルマップです。各座標におけるブロックの状況を保存します。
    /// 直接編集せず _setFillMap(_:, _:) _getFillMap(_:) を使用してください。
    private var fillMap:[[[UInt16]]] =
        Array(repeating: Array(repeating: Array(repeating: 0, count: kChankMaxZ), count: kChankMaxY), count: kChankMaxX)
    
    /// アンカーとブロックIDの対応表です。
    /// 直接編集せず _setAnchorBlockMap(_:, _:) _getAnchorBlockMap(_:) を使用してください。
    private var anchorBlockMap:[[[UInt16]]] =
        Array(repeating: Array(repeating: Array(repeating: 0, count: kChankMaxZ), count: kChankMaxY), count: kChankMaxX)
    
    /// 生成済みのノードです。チャンクの解放とともに削除されます。
    /// 直接編集せず _generateNode(_:, _:) _getNode(_:) を使用してください。
    private var allNodes:[[[SCNNode?]]] =
        Array(repeating: Array(repeating: Array(repeating: nil, count: kChankMaxZ), count: kChankMaxY), count: kChankMaxX)
    
    /// 全アンカーです。
    private var anchorMap = Set<TSVector3>()
    
    // =============================================================== //
    // MARK: - Methods -
    
    /// アンカーポイントにブロックがあれば、ブロックのSCNNodeを返します。
    func createNode(for anchorPoint:TSVector3) -> SCNNode? {
        let block = self.block(in: anchorPoint)
        
        if let node = _getNode(at: anchorPoint) { // 生成済みならば
            return node
        }
        if block.canCreateNode() { // 未生成ならば
            let node = block.createNode()
            self._setNode(node, at: anchorPoint)
            
            return node
        }
        
        return nil
    }
    
    /// アンカーポイントにブロックを設置します。
    func placeBlock(_ block:TSBlock, at anchorPoint:TSVector3) {
        guard block.canPlace(at: anchorPoint) else {return}
        
        block.willPlace(at: anchorPoint)
        
        self.anchorMap.insert(anchorPoint)
        self._setAnchoBlockMap(block, at: anchorPoint)
        
        self.delegate?.chunk(self, didBlockUpdatedAt: anchorPoint)
        
        block.didPlaced(at: anchorPoint)
    }
    
    /// アンカーポイントのブロックを破壊します。
    func destroyBlock(at anchorPoint:TSVector3) {
        let block = _getAnchoBlockMap(at: anchorPoint)
        guard block.canDestroy(at: anchorPoint) else {return}
        
        block.willDestroy(at: anchorPoint)
        
        self.anchorMap.remove(anchorPoint)
        self._setAnchoBlockMap(.air, at: anchorPoint)
        
        self.delegate?.chunk(self, didBlockUpdatedAt: anchorPoint)
        
        block.didDestroy(at: anchorPoint)
    }
    
    /// アンカーポイントにあるブロックを返します。
    func block(at anchoPoint:TSVector3) -> TSBlock {
        return _getAnchoBlockMap(at: anchoPoint)
    }
    
    /// 場所を占めているブロックを返します。かなり重いので頻繁には行わないでください。
    func block(in place:TSVector3) -> TSBlock {
        return _getFillMap(at: place)
    }
    
    /// 場所を埋めます。埋めるためのブロックは1、1）サイズである必要があります。
    func fill(with block:TSBlock, from start:TSVector3, to end:TSVector3) {
        for x in start.x16...end.x16 {
            for y in start.y16...end.y16 {
                for z in start.z16...end.z16 {
                    let place = TSVector3(x, y, z)
                    
                    self._setAnchoBlockMap(block, at: place)
                    self.delegate?.chunk(self, didBlockUpdatedAt: place)
                }
            }
        }
    }
    func fillWithAir(from start:TSVector3, to end:TSVector3) {
        fill(with: .air, from: start, to: end)
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    init(chunkPosition:TSVector2) {
        self.chunkPosition = chunkPosition
    }
    // =============================================================== //
    // MARK: - Private Methods -
    
    private func _applyFillMap(with block:TSBlock, anchor:TSVector3) {
        #warning("作る")
    }
    
    // =============================== //
    // MARK: - List Setter Getters -
    
    // MARK: - FillMap Getter and Setter -
    private func _getFillMap(at point:TSVector3) -> TSBlock {
        let (x, y, z) = _convertVector3(point)
        
        return TSBlock.block(for: fillMap[x][y][z])
    }
    private func _setFillMap(_ block:TSBlock, at point:TSVector3) {
        let (x, y, z) = _convertVector3(point)
        
        fillMap[x][y][z] = block.index
    }
    
    // MARK: - AnchoBlockMap Getter and Setter -
    private func _getAnchoBlockMap(at point:TSVector3) -> TSBlock {
        let (x, y, z) = _convertVector3(point)
        
        let id = anchorBlockMap.at(x)?.at(y)?.at(z) ?? 0
        return TSBlock.block(for: id)
    }
    private func _setAnchoBlockMap(_ block:TSBlock, at point:TSVector3) {
        let (x, y, z) = _convertVector3(point)
        
        anchorBlockMap[x][y][z] = block.index
    }
    
    // MARK: - NodeMap Getter and Setter -
    private func _setNode(_ node:SCNNode, at point:TSVector3){
        let (x, y, z) = _convertVector3(point)
        
        allNodes[x][y][z] = node
    }
    
    private func _getNode(at point:TSVector3) -> SCNNode? {
        let (x, y, z) = _convertVector3(point)
        
        return allNodes[x][y][z]
    }
    
    /// TSVector3を配列アクセス用のIndexに変換します。
    private func _convertVector3(_ vector3:TSVector3) -> (Int, Int, Int) {
        
        return (Int(vector3.x16 - 32767), Int(vector3.y16 - 32767), Int(vector3.z16 - 32767))
    }
}

extension TSChunk:Equatable {
    public static func == (left:TSChunk, right:TSChunk) -> Bool{
        return left.position == right.position
    }
}
extension TSChunk:Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.position)
    }
}
*/
