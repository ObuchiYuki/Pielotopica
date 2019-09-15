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
internal let kLevelMaxX = Int(400)
internal let kLevelMaxZ = Int(400)
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
