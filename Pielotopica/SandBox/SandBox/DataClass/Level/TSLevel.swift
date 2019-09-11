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
// MARK: - Constants -
internal let kLevelMaxX = Int(60)
internal let kLevelMaxZ = Int(60)
internal let kLevelMaxY = Int(4)

internal let kArrayAccessMargin = kLevelMaxX / 2

// =============================================================== //
// MARK: - TSLevelDelegate -

public protocol TSLevelDelegate {
    func level(_ level:TSLevel, levelDidUpdateBlockAt position:TSVector3, needsAnimation animiationFlag:Bool, withRotation rotation:TSBlockRotation)
    func level(_ level:TSLevel, levelWillDestoryBlockAt position:TSVector3)
    func level(_ level:TSLevel, levelDidDestoryBlockAt position:TSVector3)
}

extension TSLevelDelegate {
    func level(_ level:TSLevel, levelDidUpdateBlockAt position:TSVector3, needsAnimation animiationFlag:Bool, withRotation rotation:TSBlockRotation) {}
    func level(_ level:TSLevel, levelWillDestoryBlockAt position:TSVector3) {}
    func level(_ level:TSLevel, levelDidDestoryBlockAt position:TSVector3) {}
}

// =============================================================== //
// MARK: - TSLevel -
/**
 次元を管理します。
 */
@available(*, deprecated, message: "TSLevel is now deprecated. Use TSCheckGenerator instead.")
public class TSLevel {
    // =============================================================== //
    // MARK: - Properties -
    
    public var delegates = RMWeakSet<TSLevelDelegate>()
    
    /// このマップに対するNodeGaneratorです。
    internal weak var nodeGenerator:TSNodeGenerator?
    
    // =============================================================== //
    // MARK: - Private Properties -
    
    /// フィルマップです。各座標におけるブロックの状況を保存します。
    /// 直接編集せず _setFillMap(_:, _:) _getFillMap(_:) を使用してください。
    private var fillMap = [[[TSFillBlock]]]()
    
    /// アンカーとブロックIDの対応表です。
    /// 直接編集せず _setAnchorBlockMap(_:, _:) _getAnchorBlockMap(_:) を使用してください。
    private var anchorBlockMap = [[[UInt16]]]()
    
    /// ブロックのデータです。
    /// 直接編集せず _setBlockDataMap(_:, _:) _getBlockDataMap(_:) を使用してください。
    private var blockDataMap = [[[UInt8]]]()
    
    /// 全アンカーです。
    private var anchorMap = Set<TSVector3>()
    
    // =============================================================== //
    // MARK: - Methods -
    
    public func getFills(at anchorPoint:TSVector3, layerY: Int16) -> [TSVector3] {
        let size = getAnchorBlock(at: anchorPoint).getSize(at: anchorPoint)
        
        var points = [TSVector3]()
        for x in _createRange(size.x16) {
            for z in _createRange(size.z16) {
                points.append(anchorPoint + TSVector3(x, layerY, z))
                 
            }
        }
        
        return points
    }
    
    public func getAnchor(ofFill fillPoint:TSVector3) -> TSVector3? {
        let (x, y, z) = _convertVector3(fillPoint)
        
        return fillMap.at(x)?.at(y)?.at(z)?.anchor
    }
    
    public func setBlockData(_ data:TSBlockData, at point:TSVector3) {
        self._setBlockDataMap(data.value, at: point)
    }
    
    public func getBlockData(at point:TSVector3) -> TSBlockData {
        return TSBlockData(value: self._getBlockDataMap(at: point))
    }
    
    /// ブロックが置けるかどうかを調べます。
    /// 多少重たい処理です。毎フレームでの実行などは避けてくだし。
    public func canPlace(_ block:TSBlock, at position:TSVector3, atRotation rotation:TSBlockRotation) -> Bool {
        return
            block.canPlace(at: position) &&
            !_conflictionExsists(about: block, at: position, at: rotation) &&
            _getFillMap(at: position - [0, 1, 0]).canPlaceBlockOnTop(block, at: position - [0, 1, 0])
    }
    
    /// 全ブロックのアンカーを返します。
    public func getAllAnchors() -> Set<TSVector3> {
        return anchorMap
    }
    
    public func getLevelData() -> TSLevelData {
        return TSLevelData(fillMap: fillMap, anchorBlockMap: anchorBlockMap, blockDataMap: blockDataMap, anchorSet: Array(anchorMap))
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
    /// 指定するanchorPointは事前に`calculatePlacablePosition(for:, at:)`で計算されたものである必要があります。
    public func placeBlock(_ block:TSBlock, at anchorPoint:TSVector3, rotation:TSBlockRotation, forced:Bool = false) {
        if !forced { // 強制でないなら
            assert(canPlace(block, at: anchorPoint, atRotation: rotation), "Error placing block. use calculatePlacablePosition(for: ,at:) to find place to place.")
            guard block.canPlace(at: anchorPoint) else {return}
        }
        
        var rotation = rotation
        var anchorPoint = anchorPoint
        
        if block.shouldRandomRotateWhenPlaced() {
            
            rotation = TSBlockRotation.random
            
            anchorPoint = TSModelRotator.shared.calcurateAnchorPoint(
                blockSize: block.getSize(at: anchorPoint),
                initial: anchorPoint,
                for: rotation
            )
        }
        
        self._writeRotation(rotation, at: anchorPoint)
        
        block.willPlace(at: anchorPoint)
        
        self.anchorMap.insert(anchorPoint)
        self._setAnchoBlockMap(block, at: anchorPoint)
        self._fillFillMap(with: block, at: anchorPoint, blockSize: block.getSize(at: anchorPoint))
        
        delegates.forEach{$0.level(self, levelDidUpdateBlockAt: anchorPoint, needsAnimation: true, withRotation: rotation)}
        
        block.didPlaced(at: anchorPoint)
        
        self._save()
    }
    
    /// アンカーポイントのブロックを破壊します。
    public func destroyBlock(at anchorPoint:TSVector3) {
        let block = _getAnchorBlockMap(at: anchorPoint)
        
        guard block.canDestroy(at: anchorPoint) else {return}
                
        block.willDestroy(at: anchorPoint)
        delegates.forEach{$0.level(self, levelWillDestoryBlockAt: anchorPoint)}
        
        self.nodeGenerator?.destoryNode(at: anchorPoint)
        self.anchorMap.remove(anchorPoint)
        self._setAnchoBlockMap(.air, at: anchorPoint)
        self._fillFillMap(with: .air, at: anchorPoint, blockSize: block.getSize(at: anchorPoint))
        self._setBlockDataMap(0, at: anchorPoint)
        
        delegates.forEach{$0.level(self, levelDidDestoryBlockAt: anchorPoint)}
        
        self._save()
        block.didDestroy(at: anchorPoint)
    }
    
    /// アンカーポイントにあるブロックを返します。
    public func getAnchorBlock(at anchorPoint:TSVector3) -> TSBlock {
        return _getAnchorBlockMap(at: anchorPoint)
    }
    
    /// 場所を占めているブロックを返します。
    public func getFillBlock(at place:TSVector3) -> TSBlock {
        return _getFillMap(at: place)
    }
    
    public func loadLevelData(_ data:TSLevelData) {
        
        self.fillMap = data.fillMap
        self.anchorBlockMap = data.anchorBlockMap
        self.blockDataMap = data.blockDataMap
        self.anchorMap = Set(data.anchorSet)
        
        for anchor in anchorMap {
            let block = getAnchorBlock(at: anchor)
                        
            block.willPlace(at: anchor)
            let rotation = TSBlockRotation(data: getBlockData(at: anchor))
            delegates.forEach{$0.level(self, levelDidUpdateBlockAt: anchor, needsAnimation: false, withRotation: rotation)}
            
            block.didPlaced(at: anchor)
        }
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    init() {
        assert(kLevelMaxX == kLevelMaxZ, "kLevelMaxX must be equals to kLevelMaxZ.")
        
        TSLevel._initirized = self
        
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    
    private func _save() {
        getLevelData().save(stageNamed: "ground")
    }
    
    private func _createRange(_ value:Int16) -> Range<Int16> {
        if value > 0 {
            return Range(uncheckedBounds: (lower: 0       , upper: value))
        }else{
            return Range(uncheckedBounds: (lower: value+1 , upper: 1    ))
        }
    }
    
    private func _writeRotation(_ rotation:TSBlockRotation, at point:TSVector3) {
        var data = TSBlockData()
        rotation.setData(to: &data)
        
        setBlockData(data, at: point)
    }
    
    private func _conflictionExsists(about block:TSBlock, at anchorPoint:TSVector3, at rotation:TSBlockRotation) -> Bool {
        let size = block.getSize(at: anchorPoint, at: rotation)
        
        for x in _createRange(size.x16) {
            for y in _createRange(size.y16) {
                for z in _createRange(size.z16) {
                    
                    if _getFillMap(at: anchorPoint + TSVector3(x, y, z)) != .air {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    private func _fillFillMap(with block:TSBlock, at anchorPoint:TSVector3, blockSize size:TSVector3) {
        
        for xSize in _createRange(size.x16) {
            for ySize in _createRange(size.y16) {
                for zSize in _createRange(size.z16) {
                    
                    self._setFillMap(block, anchorPoint, at: anchorPoint + TSVector3(xSize, ySize, zSize))
                }
            }
        }
    }
    
    // MARK: - FillMap Getter and Setter -
    private func _getFillMap(at point:TSVector3) -> TSBlock {
        let (x, y, z) = _convertVector3(point)
        
        return fillMap.at(x)?.at(y)?.at(z).map{TSBlock.block(for: $0.index)} ?? .air
    }
    private func _setFillMap(_ block:TSBlock,_ anchor:TSVector3, at point:TSVector3) {
        let (x, y, z) = _convertVector3(point)
        
        fillMap[x][y][z] = TSFillBlock(anchor: anchor, index: block.index)
        
    }
    
    // MARK: - AnchoBlockMap Getter and Setter -
    private func _getAnchorBlockMap(at point:TSVector3) -> TSBlock {
        let (x, y, z) = _convertVector3(point)
        
        let id = anchorBlockMap.at(x)?.at(y)?.at(z) ?? 0
        return TSBlock.block(for: id)
    }
    
    private func _setAnchoBlockMap(_ block:TSBlock, at point:TSVector3) {
        let (x, y, z) = _convertVector3(point)
        
        anchorBlockMap[x][y][z] = block.index
    }
    
    private func _setBlockDataMap(_ data: UInt8, at point:TSVector3) {
        let (x, y, z) = _convertVector3(point)
        
        blockDataMap[x][y][z] = data
    }
    
    private func _getBlockDataMap(at point:TSVector3) -> UInt8 {
        let (x, y, z) = _convertVector3(point)
        
        return blockDataMap.at(x)?.at(y)?.at(z) ?? 0
    }
    
    
    /// TSVector3を配列アクセス用のIndexに変換します。
    public func _convertVector3(_ vector3:TSVector3) -> (Int, Int, Int) {
        
        return (vector3.x + kArrayAccessMargin, vector3.y, vector3.z + kArrayAccessMargin)
    }
}

extension TSLevel {
    private static var _initirized:TSLevel?
    
    public static var current:TSLevel! {
        return _initirized
    }
}

extension TSBlock {
    /// ブロックデータを返します。
    public func getBlockData(at point:TSVector3) -> TSBlockData? {
        return TSLevel.current?.getBlockData(at: point)
    }
    
    public func setBlockData(_ data:TSBlockData, at point:TSVector3) {
        
        TSLevel.current?.setBlockData(data, at: point)
    }
}
