import UIKit
import SpriteKit


class TPCaptureViewController: UIViewController {
    // ======================================================================== //
    // MARK: - Properties -
    
    static weak var initirized:TPCaptureViewController?
    
    // MARK: - UI Level -
    @IBOutlet private weak var previewView: UIView!
    @IBOutlet private weak var skView: SKView!
    @IBOutlet private weak var effectSKView: SKView!
    
    private var boundingBoxeProviders = [TPBoundingBoxProvider]()
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TPCaptureViewController.handleTap))
    
    // MARK: - Game Level -
    private var backgroundScene = SKScene()
    private var gameScene = TPCaptureUIScene()

    // MARK: - Recognition Level -
    private let visibilityManager = TPCaptureVisibilityManager.shared
    private var detector:RKObjectDetector!
    private var videoCapture:RKVideoCapture!
    
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
                
        _setupEffectView()
        _setupPreviewView()
        _setupGameScene()
        
        #if !targetEnvironment(simulator)
        setUpBoundingBoxes()
        setupDetector()
        setUpCamera()
        #endif

    }
    
    // ======================================================================== //
    // MARK: - Private Methods -
    
    // ==================================== //
    // MARK: - Handler -
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: previewView)
        
        guard let prediction = getPrediction(at: location) else {return}
        guard visibilityManager.isVisible(classIndex: prediction.classIndex) else {return}
        
        visibilityManager.didPredictionGet(for: prediction.classIndex)
        
        _showPredictionData(prediction)
        _showEffect(at: location)
    }
    
    // ==================================== //
    // MARK: - UI level -
    
    private func _showEffect(at location:CGPoint) {
        let size = previewView.frame.size
        let location = CGPoint(x: location.x, y: size.height - location.y)
        
        let path = Bundle.main.path(forResource: "getItemParticle", ofType: "sks")!
        let particle = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! SKEmitterNode
        particle.position = location
        
        effectSKView.isPaused = false
        effectSKView.scene?.addChild(particle)
        
        particle.run(.sequence([
            .wait(forDuration: 0.1),
            .run {particle.particleBirthRate = 0},
            .wait(forDuration: 1),
            .run{particle.removeFromParent()},
            .wait(forDuration: 1),
            .run{self.effectSKView.isPaused = true},
        ]))
    }
    
    private func _setupEffectView() {
        let scene = SKScene(size: [300, 300])
        effectSKView.presentScene(scene)
        effectSKView.scene?.backgroundColor = .clear
        effectSKView.backgroundColor = .clear
        effectSKView.allowsTransparency = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            self.effectSKView.isPaused = true
        })
    }
    
    private func _setupPreviewView() {
        previewView.clipsToBounds = true
        previewView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func showBoundingBoxes(predictions: [RKObjectDetector.Prediction]) {
        currentShowingPredictions = predictions
        
        for i in 0..<boundingBoxeProviders.count {
            if i < predictions.count {
                let prediction = predictions[i]
                
                guard visibilityManager.isVisible(classIndex: prediction.classIndex) else {
                    boundingBoxeProviders[i].hide()
                    return
                }
                 
                let label = prediction.name
                                
                boundingBoxeProviders[i].show(at: prediction.rect(for: previewView.frame.size).origin, with: label)
            } else {
                boundingBoxeProviders[i].hide()
            }
        }
    }

    // ==================================== //
    // MARK: - Recognition level -
    
    private func setupDetector() {
        detector.iouThreshold = 0.2
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
            boundingBoxeProviders.append(TPBoundingBoxProvider())
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
    
    // ==================================== //
    // MARK: - Game level -
    
    private func _showPredictionData(_ prediction:RKObjectDetector.Prediction) {
        let value = TPMaterialValueMap.allValues[prediction.classIndex]
        
        TSMaterialData.shared.addIron(value.iron)
        TSMaterialData.shared.addWood(value.wood)
        TSMaterialData.shared.addCircit(value.circit)
        
        TSFuelData.shared.addFuel(value.fuel)
        TSFuelData.shared.addHeart(value.heart)
        
        self.gameScene.showPrediction(withObjectNamed: prediction.name, value: value)
    }
    
    private func _setupGameScene() {
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

