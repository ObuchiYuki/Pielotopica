#  GameKit

`GameKit` は `SpriteKit` と `SceneKit` の結合、より良い使用を提供します。

###  Classes

- `GKViewController`
    ゲーム画面を管理する基本のViewControllerです。
    
    3D, 2DどちらのSceneも表示することができます。

    InterfaceBuilderを組み合わせることも可能。
    
- `GKSceneHolder`
    `GameKit` が `SpriteKit` と `SceneKit` を扱う都合上、
    
複数のシーンを一つにまとめる必要があるため導入
    
- 2Dの背景シーン + Safeシーン
- 3Dのシーン + Safeシーン
    
のいずれかを保持 。シーンは実際に使用するまで作成しない。
    
- `GKSafeScene`
    UIをiPhoneの画面に合わせて調整しなくて済むように導入
    
    このシーンは常に `(375, 700) = GKSafeScene.sceneSize` のサイズであり、
    
    その中にUIを構築すれば画面サイズに合わせて自動で調整される。
    
- `GKButtonNode`
    SpriteKitでのボタン使用のために作成
    
    使用方法はほとんど `UIButton` と同様
    
    
    
    コンポーネントはオーバーライドして作成
    
    ```swift
    func buttonDidSelect() {}
    func buttonDidUnselect() {}
    ```
    この点通常の`UIButton`よりも容易にアクションを付けられる。
    
- `GK3DSceneController`

    `SCNScene `に `update`などの基礎的なコンポーネントがなかったため作成。

    `UIViewController`と使用感は近い


    各メソッドのコメントを読むこと
    
- `Extensitons`
    `SceneKit`+`SpriteKit`の拡張色々
    

    

    


