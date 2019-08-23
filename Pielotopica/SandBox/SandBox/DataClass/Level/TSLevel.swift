//
//  TSLevel.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/14.
//  Copyright © 2019 yuki. All rights reserved.
//

import SceneKit
import RxCocoa
import RxSwift

// =============================================================== //
// MARK: - Consts -
internal let kLevelMaxX = Int(2048)
internal let kLevelMaxZ = Int(2048)
internal let kLevelMaxY = Int(256)

private let kArrayAccessMargin = 1024

// =============================================================== //
// MARK: - TSLevelDelegate -

public protocol TSLevelDelegate:class {
    func level(_ level:TSLevel, levelDidUpdateBlockAt position:TSVector3)
    func level(_ level:TSLevel, levelDidDestoryBlockAt position:TSVector3)
}

// =============================================================== //
// MARK: - TSLevel -

/**
 次元を管理します。
 */
public class TSLevel {
    // =============================================================== //
    // MARK: - Properties -
    public weak var delegate:TSLevelDelegate?
    
    /// このマップに対するNodeGaneratorです。
    internal weak var nodeGenerator:TSNodeGenerator?
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    /// フィルマップです。各座標におけるブロックの状況を保存します。
    /// 直接編集せず _setFillMap(_:, _:) _getFillMap(_:) を使用してください。
    private var fillMap:[[[UInt16]]] =
        Array(repeating: Array(repeating: Array(repeating: 0, count: kLevelMaxZ), count: kLevelMaxY), count: kLevelMaxX)
    
    /// アンカーとブロックIDの対応表です。
    /// 直接編集せず _setAnchorBlockMap(_:, _:) _getAnchorBlockMap(_:) を使用してください。
    private var anchorBlockMap:[[[UInt16]]] =
        Array(repeating: Array(repeating: Array(repeating: 0, count: kLevelMaxZ), count: kLevelMaxY), count: kLevelMaxX)
    
    /// アンカーとブロックIDの対応表です。
    /// 直接編集せず _setAnchorBlockMap(_:, _:) _getAnchorBlockMap(_:) を使用してください。
    private var blockDataMap:[[[UInt8]]] =
        Array(repeating: Array(repeating: Array(repeating: 0, count: kLevelMaxZ), count: kLevelMaxY), count: kLevelMaxX)
    
    /// 全アンカーです。
    private var anchorMap = Set<TSVector3>()
    
    // =============================================================== //
    // MARK: - Methods -
    
    /// ブロックが置けるかどうかを調べます。
    /// 多少重たい処理です。毎フレームでの実行などは避けてくだし。
    public func canPlace(_ block:TSBlock, at position:TSVector3) -> Bool {
        
        let f1 = block.canPlace(at: position)
        let f2 = !_conflictionExsists(about: block, at: position)
        
        let under = position - [0, 1, 0]
        let f3 = _getFillMap(at: under).canPlaceBlockOnTop(block, at: under)
        
        return f1 && f2 && f3
    }
    
    /// 全ブロックのアンカーを返します。
    public func getAllAnchors() -> Set<TSVector3> {
        return anchorMap
    }
    
    /// ブロックがおける場所を調べます。
    /// 置けない場合は、nilを返します。
    public func calculatePlacablePosition(for block:TSBlock, at point:TSVector2) -> TSVector3? {
        var position = TSVector3(point.x16, Int16(UInt8.max), point.z16)
        
        while ( self.getFillBlock(at: position).isAir && position.y16 > 0) { // 0以上・空気なしまで探索する。
            
            position.y16 -= 1
        }
        
        if ( self.getFillBlock(at: position).canPlaceBlockOnTop(block, at: position) ) { // 探索後のブロックが上に物を置けるか確かめる。
            position.y16 += 1 // 実際に置く場所に変換
            if block.canPlace(at: position){ // ブロックが置けるかを確かめる。
                return position
            }
        }
        
        return nil
    }
    
    /// アンカーポイントにブロックを設置します。
    /// 指定するanchorPointは事前に`calculatePlacablePosition(_:,_:)`で計算されたものである必要があります。
    /// forceオプションに速度的な差はありません。
    public func placeBlock(_ block:TSBlock, at anchorPoint:TSVector3, forced:Bool = false) {
        if !forced { // 強制でないなら
            assert(canPlace(block, at: anchorPoint), "Error placing block. use calculatePlacablePosition to find place to place.")
            guard block.canPlace(at: anchorPoint) else {return}
        }
        
        block.willPlace(at: anchorPoint)
        
        self.anchorMap.insert(anchorPoint)
        self._setAnchoBlockMap(block, at: anchorPoint)
        self._fillFillMap(with: block, at: anchorPoint)
        
        self.delegate?.level(self, levelDidUpdateBlockAt: anchorPoint)
        
        block.didPlaced(at: anchorPoint)
    }
    
    /// アンカーポイントのブロックを破壊します。
    public func destroyBlock(at anchorPoint:TSVector3) {
        let block = _getAnchoBlockMap(at: anchorPoint)
        guard block.canDestroy(at: anchorPoint) else {return}
        
        block.willDestroy(at: anchorPoint)
        
        self.anchorMap.remove(anchorPoint)
        self._setAnchoBlockMap(.air, at: anchorPoint)
        self._fillFillMap(with: .air, at: anchorPoint)
        
        self.delegate?.level(self, levelDidUpdateBlockAt: anchorPoint)
        
        block.didDestroy(at: anchorPoint)
    }
    
    /// アンカーポイントにあるブロックを返します。
    public func getAnchorBlock(at anchoPoint:TSVector3) -> TSBlock {
        return _getAnchoBlockMap(at: anchoPoint)
    }
    
    /// 場所を占めているブロックを返します。
    public func getFillBlock(at place:TSVector3) -> TSBlock {
        return _getFillMap(at: place)
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    private func _conflictionExsists(about block:TSBlock, at anchorPoint:TSVector3) -> Bool {
        let size = block.size
        
        for x in 0..<size.x16 {
            for y in 0..<size.y16 {
                for z in 0..<size.z16 {
                    
                    if _getFillMap(at: anchorPoint + TSVector3(x, y, z)) != .air {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func _fillFillMap(with block:TSBlock, at anchorPoint:TSVector3) {
        let size = block.size
        
        for xSize in 0..<size.x16 {
            for ySize in 0..<size.y16 {
                for zSize in 0..<size.z16 {
                    
                    self._setFillMap(block, at: anchorPoint + TSVector3(xSize, ySize, zSize))
                }
            }
        }
    }
    
    // MARK: - FillMap Getter and Setter -
    private func _getFillMap(at point:TSVector3) -> TSBlock {
        let (x, y, z) = _convertVector3(point)
        
        return fillMap.at(x)?.at(y)?.at(z).map{TSBlock.block(for: $0)} ?? .air
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
    
    /// TSVector3を配列アクセス用のIndexに変換します。
    public func _convertVector3(_ vector3:TSVector3) -> (Int, Int, Int) {
        
        return (vector3.x + kArrayAccessMargin, vector3.y, vector3.z + kArrayAccessMargin)
    }
}

extension TSLevel {
    public static func current() -> TSLevel {
        return grobal
    }
    
    /// Singleton for ground Level
    public static let grobal = TSLevel()
    
    /// Singleton for nezer Level
    public static let nezer = TSLevel()
}
