
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
    
    private var boundingBoxes = [BoundingBox]()
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
        
        previewView.isUserInteractionEnabled = true
        previewView.clipsToBounds = true
        
        tapGestureRecognizer.numberOfTapsRequired = 1
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
        
        for i in 0..<boundingBoxes.count {
            if i < predictions.count {
                let prediction = predictions[i]
                let label = prediction.name
                
                let color = colors[prediction.classIndex]
                
                boundingBoxes[i].show(frame: prediction.rect(for: previewView.frame.size), label: label, color: color)
            } else {
                boundingBoxes[i].hide()
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
            
            for box in self.boundingBoxes {
                box.addToLayer(self.previewView.layer)
            }
            
            self.videoCapture.start()
        }
        
    }
    
    private func setUpBoundingBoxes() {
        for _ in 0..<YOLO.maxBoundingBoxes {
            boundingBoxes.append(BoundingBox())
        }
        
        for r: CGFloat in [0.2, 0.4, 0.6, 0.8, 1.0] {
            for g: CGFloat in [0.3, 0.7, 0.6, 0.8] {
                for b: CGFloat in [0.4, 0.8, 0.6, 1.0] {
                    colors.append(UIColor(red: r, green: g, blue: b, alpha: 1))
                }
            }
        }
    }
}

extension CaptureViewController: RKObjectDetectorDelegate {
    func detector(_ detector: RKObjectDetector, didDetectObjectsWith predictions: [RKObjectDetector.Prediction]) {
        
        self.showBoundingBoxes(predictions: predictions)
    }
}

