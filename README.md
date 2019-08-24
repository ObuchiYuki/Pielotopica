# Topica



`BlockPlaceHelper`

→  

- `BlockEditHelper`
- `BlockPlaceHelper`
- `BlockRemoveHelper`
- `BlockMoveHelper`

+



##### `BlockEditHelperDelegate`

```swift
protocol BlockEditHelperDelegate :class {
  
    /// ガイドノードを設置してください。
    func blockPlaceHelper(placeGuideNodeWith node: SCNNode, at position: TSVector3)
    /// ブロック設置の終了処理をしてください。
    func blockPlacehelper(endBlockPlacingWith node: SCNNode)
    /// ガイドノードを移動させてください。
    func blockPlaceHelper(moveNodeWith node:SCNNode, to position: TSVector3)
}
```



## `BlockEditHelper`

ブロック置くことの処理を担当する

```swift
// ================================================================= //
// Properties

// Block 
let block:TSBlock
// ガイドノード
var guideNode: SCNNode

// ======================================== //
// Editが終わったかどうか（この時点でこのHelperはもう使われない）
var isEditingEnd: Bool
// 現在のガイドノードの場所
var nodePosition: TSVector3

// ======================================== //
// Gesture
// どこからdragを始めたか
var dragStartingPosition: TSVector2
// 最初のノードの場所
var initialNodePosition: TSVector3

// ======================================== //
// 現在の回転状況
var _blockRotation = 0
var _roataion:TSBlockRotation // accesser
// ================================================================ //
// Methods

func rotateCurrentBlock()
func startEditing(from anchorPoint: TSVector3, startRotation rotation: Int)


func endBlockEditing()
func canEndBlockEditing() -> Bool

// gesture 
func onTouch()
func blockDidDrag(with vector: CGPoint)

init(delegate:TPBlockPlaceHelperDelegate, block:TSBlock)

// ================================================================ //
// private

func _createGuideNode() -> SCNNode
func _checkBlockPlaceability()
func _anchorPointDeltaMovement(blockSize: TSVector3, for rotation:Int) -> TSVector3
```



















