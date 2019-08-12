/// 一時的にチャンクシステムは凍結中
/*//
//  TSLevel.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/13.
//  Copyright © 2019 yuki. All rights reserved.
//

import RxCocoa
import RxSwift
import SceneKit

// =============================================================== //
// MARK: - TSLevel -

protocol TSLevelDelegate :class{
    func level(_ level:TSLevel, levelDidUpdateChunkAt chunkPosition:TSVector2)
    func level(_ level:TSLevel, chunkDidUpdateBlockWith chunk:TSChunk, at worldCoodinate:TSVector3)
}
/**
 世界のチャンクです。
 */
final public class TSLevel {
    // =============================================================== //
    // MARK: - Properties -
    
    /// 地上を表します。
    public static let global = TSLevel()
    
    public var delegate:TSLevelDelegate?

    // =============================================================== //
    // MARK: - Private Properties -
    private var loadingChunks = [TSChunk]()
    
    private var currentUserChunkPosition:TSVector3
    
    private var renderChunkDistance:Int16 = 0
    
    
    private let bag = DisposeBag()

    // =============================================================== //
    // MARK: - Methods -
    
    /// チャンクを更新します。
    func updateChunks() {
        _updateToRemoveUnusedChunks()
        _updateToCreateNewChunks()
    }
    
    /// 場所にあるチャンクを返します。
    /// 未生成の場合はnilを返します。
    func chunk(at chunkPosition:TSVector2) -> TSChunk? {
        return loadingChunks.first(where: {$0.chunkPosition == chunkPosition})
    }
    
    func chunkCoodinate(of worldCoodinate:TSVector3, with chunk:TSChunk) -> TSVector3 {
        return worldCoodinate - chunk.sandboxPosition
    }
    
    // =============================================================== //
    // MARK: - Constructor -
    
    init() {
        // Rx registrations
        TPPreference.default.renderDistance.subscribe{[weak self] in
            $0.element.map{self?.renderChunkDistance = Int16($0)}
        }.disposed(by: bag)
        
        TSSandboxPlayerSystem.default.getPlayer().position.subscribe{[weak self] in
            $0.element.map{self?.currentUserChunkPosition = TSVector3($0) * 10}
        }.disposed(by: bag)
        
    }
    // =============================================================== //
    // MARK: - Private Methods -
    
    /// 不要になったチャンクを削除します。
    private func _updateToRemoveUnusedChunks() {
        for loadingChunk in loadingChunks {
            if _playerDistance(to: loadingChunk) > renderChunkDistance {
                loadingChunks.remove(of: loadingChunk)
                delegate?.level(self, levelDidUpdateChunkAt: loadingChunk.chunkPosition)
            }
        }
    }
    
    /// 必要になるチャンクを読み込みます。
    private func _updateToCreateNewChunks() {
        let minDisX = currentUserChunkPosition.x16 - renderChunkDistance
        let maxDisX = currentUserChunkPosition.x16 + renderChunkDistance
        let minDisZ = currentUserChunkPosition.z16 - renderChunkDistance
        let maxDisZ = currentUserChunkPosition.z16 + renderChunkDistance
        
        var uncreatedChunkPositions = [CGPoint]()
        
        let loadedChunkPoints = loadingChunks.map({$0.chunkPosition.point})
        
        for x in minDisX...maxDisX {
            for z in minDisZ...maxDisZ {
                let point = TSVector2(x, z)
                
                if !( loadedChunkPoints.contains(point) ) {
                    self._createChunk(at: point)
                }
            }
        }
    }
    /// 実際にチャンクを生成します。
    private func _createChunk(at chunkPosition:TSVector2) {
        let chunk = TSChunk(chunkPosition: chunkPosition)
        self.loadingChunks.append(contentsOf: chunk)
        
        delegate?.level(self, levelDidUpdateChunkAt: chunkPosition)
    }
    
    private func _playerDistance(to chunk:TSChunk) -> Int {
        return (currentUserChunkPosition.x - chunk.chunkPosition.x) + (currentUserChunkPosition.z - chunk.chunkPosition.z)
    }
    
    private func _convertToWorldCoodinate(from chunkLocalCoodinate:TSVector3, with chunk:TSChunk) -> TSVector3 {
        return chunk.sandboxPosition + chunkLocalCoodinate
    }
}
extension TSLevel:TSChunkDelegate {
    public func chunk(_ chunk: TSChunk, didBlockUpdatedAt position: TSVector3) {
        let worldCoodinate = _convertToWorldCoodinate(from: position, with: chunk)
        
        self.delegate?.level(self, chunkDidUpdateBlockWith: chunk, at: worldCoodinate)
    }
}
*/
