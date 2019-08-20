
import UIKit


class CaptureViewController: UIViewController {
    // ======================================================================== //
    // MARK: - Private Properties -
    private let detector = RKObjectDetector()
    private let videoCapture = RKVideoCapture()
    
    private var boundingBoxes = [BoundingBox]()
    private var colors: [UIColor] = []
    
    // ======================================================================== //
    // MARK: - Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBoundingBoxes()
        setupDetector()
        setUpCamera()
    }
    
    // ======================================================================== //
    // MARK: - Private Methods -
    
    // ==================================== //
    // MARK: - UI level -
    
    private func showBoundingBoxes(predictions: [RKObjectDetector.Prediction]) {
        
        for i in 0..<boundingBoxes.count {
            if i < predictions.count {
                let prediction = predictions[i]
                let label = String(format: "%@ %.1f", prediction.name, prediction.confidence)
                
                let color = colors[prediction.classIndex]
                
                boundingBoxes[i].show(frame: prediction.rect(for: view.bounds.size), label: label, color: color)
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

        videoCapture.setUp {success in
            guard success else {return}
            
            let previewLayer = self.videoCapture.createPreviewLayer()
            
            self.view.layer.insertSublayer(previewLayer, at: 0)
            previewLayer.frame.size = self.view.frame.size
            
            for box in self.boundingBoxes {
                box.addToLayer(self.view.layer)
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

