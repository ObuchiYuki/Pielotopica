
import UIKit


class CaptureViewController: UIViewController {
    // ======================================================================== //
    // MARK: - IBOutlet -
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    // ======================================================================== //
    // MARK: - Private Properties -
    private let detector = RKObjectDetector()
    private let videoCapture = RKVideoCapture()
    
    private var boundingBoxeProviders = [BoundingBoxProvider]()
    private var colors = [UIColor]()
    
    lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CaptureViewController.handleTap(_:)))
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: previewView)
        
        if let name = prediction(at: location)?.name {
            textView.text.append(name + "\n")
        }
    }
    
    var currentShowingPredictions = [RKObjectDetector.Prediction]()
    
    private func prediction(at point: CGPoint) -> RKObjectDetector.Prediction? {
        for prediction in currentShowingPredictions {
            let rect = prediction.rect(for: previewView.frame.size)
            if rect.contains(point) {
                return prediction
            }
        }
        
        return nil
    }
    
    // ======================================================================== //
    // MARK: - Methods -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}

extension CaptureViewController: RKObjectDetectorDelegate {
    func detector(_ detector: RKObjectDetector, didDetectObjectsWith predictions: [RKObjectDetector.Prediction]) {
        
        self.showBoundingBoxes(predictions: predictions)
    }
}

