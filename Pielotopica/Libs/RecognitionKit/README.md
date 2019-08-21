#  RecognitionKit

**© 2019 Obuchi Yuki. All rights reserved.**

`Pielotopica`の画像認識部分を担当する`Kit`です。


### `Classes`

- #### `RKVideoCapture`
    
    カメラの入力、`AVCaptureSession`周りを担当します。
    
    - `setDetector(_:)`
    
        `RKObjectDetector`をセットしてください。すべてのメソッドより先に読んでください。
    
    - `setUp(sessionPreset:, completion:)`
    
        セッションをセットアップします。非同期的に行われます。
    
    - `start()`
    
        カメラを起動します。
    
        必ず`setUp`を読んでから、呼び出してください。
    
    - `createPreviewLayer()`
    
        `Preview`用の`Layer`を返します。大きさは `0 `なので、Viewに合わせて調整してください。
    
        必ず`setUp`を読んでから、呼び出してください。
    
- #### `RKObjectDetector`

    画像認識まわりの処理を提供します。

    - `confidenceThreshold `   `default = 0.7`

      認識された物体を返すかどうかを認識の確度に基づいて判別する閾値です。

      `confidenceThreshold`をあげれば、認識される物体の確度が上がります。

      (認識されるものの数は減ります。)

      

    - `iouThreshold`    `default = 0.3`

      IOUについては[R-CNN公式論文](https://www.cv-foundation.org/openaccess/content_cvpr_2014/papers/Girshick_Rich_Feature_Hierarchies_2014_CVPR_paper.pdf)を参照

      

      IOUの値に基づいて認識された物体を返すかどうかを決めます。

      iouThresholdを下げれば、物体の重複認識は減ります。

      (近くにあるものが省略される可能性が上がります。)















