
import UIKit
import SpriteKit


class TPCaptureViewController: UIViewController {
    
    static weak var initirized:TPCaptureViewController?
    
    // ======================================================================== //
    // MARK: - IBOutlet -
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var skView: SKView!
    
    private var backgroundScene = SKScene()
    private var gameScene = TPCaptureUIScene()
    
    // ======================================================================== //
    // MARK: - Private Properties -
    private var detector:RKObjectDetector!
    private var videoCapture:RKVideoCapture!
    
    private var boundingBoxeProviders = [BoundingBoxProvider]()
    
    lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TPCaptureViewController.handleTap(_:)))
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: previewView)
        
    }
    
    private var currentShowingPredictions = [RKObjectDetector.Prediction]()
    
    
    // ======================================================================== //
    // MARK: - Methods -
    
    /// AIを読み込みます。 思い処理です。(3-5秒)
    /// Presentationより前に呼び出してください。
    /// 別にallocしかからといってfreeは必要ないです。これはSwiftです。
    public func allocAI() {
        detector = RKObjectDetector()
        videoCapture = RKVideoCapture()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TPCaptureViewController.initirized = self
        _loadGameScene()
        
        detector.iouThreshold = 0.2
        
        previewView.clipsToBounds = true
        previewView.addGestureRecognizer(tapGestureRecognizer)
        
        setUpBoundingBoxes()
        setupDetector()
        setUpCamera()
    }
    
    // ======================================================================== //
    // MARK: - Private Methods -
    
    // ==================================== //
    // MARK: - UI level -
    
    private func showBoundingBoxes(predictions: [RKObjectDetector.Prediction]) {
        currentShowingPredictions = predictions
        
        for i in 0..<boundingBoxeProviders.count {
            if i < predictions.count {
                let prediction = predictions[i]
                let label = prediction.name
                                
                boundingBoxeProviders[i].show(at: prediction.rect(for: previewView.frame.size).origin, with: label)
            } else {
                boundingBoxeProviders[i].hide()
            }
        }
    }

    // ==================================== //
    // MARK: - Constructing -
    
    private func setupDetector() {
        detector.delegate = self
        
    }
    
    private func setUpCamera() {
        videoCapture.setDetector(self.detector)

        videoCapture.setUp { success in
            guard success else {fatalError("Something happened while luanching camera.")}
            
            let previewLayer = self.videoCapture.createPreviewLayer()
            
            previewLayer.frame.size = self.previewView.frame.size
            self.previewView.layer.insertSublayer(previewLayer, at: 0)
            
            for box in self.boundingBoxeProviders {
                box.addToLayer(self.previewView.layer)
            }
            
            self.videoCapture.start()
        }
        
    }
    
    private func setUpBoundingBoxes() {
        for _ in 0..<YOLO.maxBoundingBoxes {
            boundingBoxeProviders.append(BoundingBoxProvider())
        }
    }
    
    private func getPrediction(at point: CGPoint) -> RKObjectDetector.Prediction? {
        for prediction in currentShowingPredictions {
            let rect = prediction.rect(for: previewView.frame.size)
            if rect.contains(point) {
                return prediction
            }
        }
        
        return nil
    }
    
    private func _loadGameScene() {
        skView.backgroundColor = .clear
        
        backgroundScene.scaleMode = .aspectFill
        backgroundScene.backgroundColor = .clear
        backgroundScene.size = GKSafeScene.sceneSize
        
        skView.presentScene(backgroundScene)
        
        _loadRootNode(gameScene.rootNode)
    }
    
    private func _calculateRootNodeScale(with viewSize:CGSize) -> CGFloat {
        
        let estimatedBGScale = GKSafeScene.sceneSize.aspectFillRatio(to: viewSize)
        let rootNodeScale = GKSafeScene.sceneSize.aspectFitRatio(to: viewSize) * (1 / estimatedBGScale)
        
        return rootNodeScale
    }
    
    /// RootNodeのサイズ変化などを行い読み込みます。・
    private func _loadRootNode(_ rootNode:SKSpriteNode) {
        rootNode.removeFromParent()
        rootNode.name = "root"
        
        rootNode.size = GKSafeScene.sceneSize
        rootNode.position = GKSafeScene.sceneSize.point / 2
        
        let rootNodeScale = _calculateRootNodeScale(with: UIScreen.main.bounds.size)
        rootNode.setScale(rootNodeScale)
        
        self.backgroundScene.addChild(rootNode)
    }
}

extension TPCaptureViewController: RKObjectDetectorDelegate {
    func detector(_ detector: RKObjectDetector, didDetectObjectsWith predictions: [RKObjectDetector.Prediction]) {
        
        self.showBoundingBoxes(predictions: predictions)
    }
}

