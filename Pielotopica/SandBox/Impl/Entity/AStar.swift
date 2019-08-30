
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

/// A*アルゴリズム
class AStar {
    private var _fieldSize:Int
    private var _nodes:[[Node?]]
    private var _openNodes:[[Node?]]
    private var _closedNodes:[[Node?]]

    /// 斜め移動の場合のコスト
    private var _diagonalMoveCost:Float

    /// 使用する前に実行して初期化してください
    public init(size:Int) {
        _fieldSize = size;
        
        _nodes = Array(repeating: Array(repeating: nil, count: _fieldSize), count: _fieldSize)
        _openNodes = Array(repeating: Array(repeating: nil, count: _fieldSize), count: _fieldSize)
        _closedNodes = Array(repeating: Array(repeating: nil, count: _fieldSize), count: _fieldSize)
        _diagonalMoveCost = 1.414

        for x in 0..<size {
            for y in 0..<size {
                _nodes[x][y] = Node.createBlankNode(TSVector2(x, y))
                _openNodes[x][y] = Node.createBlankNode(TSVector2(x, y))
                _closedNodes[x][y] = Node.createBlankNode(TSVector2(x, y))
            }
        }
    }

    func setDiagonalMoveCost(_ cost:Float) {
        _diagonalMoveCost = cost
    }

    /// ルート検索開始
    func searchRoute(_ startNodeId:TSVector2, _ goalNodeId:TSVector2,_ routeList: inout Array<TSVector2>) -> Bool {
        resetNode();
        if (startNodeId == goalNodeId) {
            print("{startNodeId}/{goalNodeId}/同じ場所なので終了")
            return false
        }

        for x in 0..<_fieldSize {
            for y in 0..<_fieldSize {
                _nodes[x][y]!.updateGoalNodeId(goalNodeId);
                _openNodes[x][y]!.updateGoalNodeId(goalNodeId);
                _closedNodes[x][y]!.updateGoalNodeId(goalNodeId);
            }
        }
        
        // スタート地点の初期化
        _openNodes[startNodeId.x][startNodeId.z] = Node.createNode(startNodeId, goalNodeId);
        _openNodes[startNodeId.x][startNodeId.z]!.setFromNodeId(startNodeId);
        _openNodes[startNodeId.x][startNodeId.z]!.add();

        while (true) {
            let bestScoreNodeId = getBestScoreNodeId();
            openNode(bestScoreNodeId, goalNodeId)

            // ゴールに辿り着いたら終了
            if (bestScoreNodeId == goalNodeId) {
                break
            }
        }

        self.resolveRoute(startNodeId, goalNodeId, &routeList);
        return true
    }

    func resetNode() {
        for x in 0..<_fieldSize {
            for y in 0..<_fieldSize {
                _nodes[x][y]!.clear();
                _openNodes[x][y]!.clear();
                _closedNodes[x][y]!.clear();
            }
        }
    }

    // ノードを展開する
    func openNode(_ bestNodeId:TSVector2, _ goalNodeId:TSVector2) {
        // 4方向走査
        for dx in -1..<2 {
            for dy in -1..<2 {
                let cx = bestNodeId.x + dx;
                let cy = bestNodeId.z + dy;

                if (checkOutOfRange(dx, dy, bestNodeId.x, bestNodeId.z) == false) {
                    continue
                }

                if (_nodes[cx][cy]!.isLock) {
                    continue
                }

                // 縦横で動く場合はコスト : 1
                // 斜めに動く場合はコスト : _diagonalMoveCost
                let addCost = dx * dy == 0 ? 1 : _diagonalMoveCost;
                _nodes[cx][cy]!.setMoveCost(_openNodes[bestNodeId.x][bestNodeId.z]!.moveCost + Double(addCost));
                _nodes[cx][cy]!.setFromNodeId(bestNodeId);

                // ノードのチェック
                updateNodeList(cx, cy, goalNodeId);
            }
        }

        // 展開が終わったノードは closed に追加する
        _closedNodes[bestNodeId.x][bestNodeId.z] = _openNodes[bestNodeId.x][bestNodeId.z];
        // closedNodesに追加
        _closedNodes[bestNodeId.x][bestNodeId.z]!.add();
        // openNodesから削除
        _openNodes[bestNodeId.x][bestNodeId.z]!.remove();
    }

    /// 走査範囲内チェック
    func checkOutOfRange(_ dx:Int,_ dy:Int,_ x:Int,_ y:Int) -> Bool {
        if (dx == 0 && dy == 0) {
            return false;
        }

        let cx = x + dx;
        let cy = y + dy;

        if cx < 0 || cx == _fieldSize || cy < 0 || cy == _fieldSize {
            return false;
        }

        return true;
    }

    /// ノードリストの更新
    func updateNodeList(_ x:Int,_ y:Int,_ goalNodeId:TSVector2) {
        if (_openNodes[x][y]!.isActive) {
            // より優秀なスコアであるならMoveCostとfromを更新する
            if (_openNodes[x][y]!.getScore() > _nodes[x][y]!.getScore()) {
                // Node情報の更新
                _openNodes[x][y]!.setMoveCost(_nodes[x][y]!.moveCost);
                _openNodes[x][y]!.setFromNodeId(_nodes[x][y]!.fromNodeId);
            }
        } else if (_closedNodes[x][y]!.isActive) {
            // より優秀なスコアであるなら closedNodesから除外しopenNodesに追加する
            if (_closedNodes[x][y]!.getScore() > _nodes[x][y]!.getScore()) {
                _closedNodes[x][y]!.remove();
                _openNodes[x][y]!.add();
                _openNodes[x][y]!.setMoveCost(_nodes[x][y]!.moveCost);
                _openNodes[x][y]!.setFromNodeId(_nodes[x][y]!.fromNodeId);
            }
        } else {
            _openNodes[x][y] = Node(TSVector2(x, y), goalNodeId);
            _openNodes[x][y]!.setFromNodeId(_nodes[x][y]!.fromNodeId);
            _openNodes[x][y]!.setMoveCost(_nodes[x][y]!.moveCost);
            _openNodes[x][y]!.add();
        }
    }

    func resolveRoute(_ startNodeId: TSVector2, _ goalNodeId: TSVector2, _ result: inout Array<TSVector2>) {
        result = []

        var node = _closedNodes[goalNodeId.x][goalNodeId.z]!
        result.append(goalNodeId);

        var cnt = 1;
        // 捜査トライ回数を1000と決め打ち(無限ループ対応)
        let tryCount = 1000;
        var isSuccess = false;
        while (cnt < tryCount) {
            cnt += 1
            
            let beforeNode = result[0];
            if (beforeNode == node.fromNodeId) {
                // 同じポジションなので終了
                print("同じポジションなので終了失敗 \(beforeNode) / \(node.fromNodeId!) / \(goalNodeId)")
                break
            }

            if (node.fromNodeId == startNodeId) {
                isSuccess = true;
                break;
            } else {
                // 開始座標は結果リストには追加しない
                result.insert(node.fromNodeId, at: 0);
            }

            node = _closedNodes[node.fromNodeId.x][node.fromNodeId.z]!;
        }

        if (isSuccess == false) {
            print("失敗 \(startNodeId) / \(node.fromNodeId!)");
        }
    }

    /// 最良のノードIDを返却
    func getBestScoreNodeId() -> TSVector2 {
        var result = TSVector2(0, 0);
        var min = Double.greatestFiniteMagnitude
        for x in 0..<_fieldSize {
            for y in 0..<_fieldSize {
                if (_openNodes[x][y]!.isActive == false) {
                    continue
                }

                if (min > _openNodes[x][y]!.getScore()) {
                    // 優秀なコストの更新(値が低いほど優秀)
                    min = _openNodes[x][y]!.getScore();
                    result = _openNodes[x][y]!.nodeId;
                }
            }
        }

        return result;
    }

    /// ノードのロックフラグを変更
    func setLock(_ lockNodeId: TSVector2, _ isLock:Bool) {
        _nodes[lockNodeId.x][lockNodeId.z]!.setIsLock(isLock);
    }
}
