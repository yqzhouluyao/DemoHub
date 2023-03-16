//
//  MachineLearningViewController.swift
//  DemoHub
//
//  Created by zhouluyao on 3/17/23.
//

import UIKit
import CoreML
import Vision

@available(iOS 12.0, *)
class MachineLearningViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var photoLibraryButton: UIButton!
    @IBOutlet var resultsView: UIView!
    @IBOutlet var resultsLabel: UILabel!
    @IBOutlet var resultsConstraint: NSLayoutConstraint!
    
    var firstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        resultsView.alpha = 0
        resultsLabel.text = "choose or take a photo"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstTime {
            showResultView(delay: 0.5)
            firstTime = false
        }
    }
    
    func showResultView(delay : TimeInterval = 0.1) {
        resultsConstraint.constant = 100
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6) {
            self.resultsView.alpha = 1
            self.resultsConstraint.constant = -10
            self.view.layoutIfNeeded()
        }
    }
    
    func hideResultView() {
        UIView.animate(withDuration: 0.1) {
            self.resultsView.alpha = 0
        }
    }
    
    @IBAction func takePicture() {
      presentPhotoPicker(sourceType: .camera)
    }

    @IBAction func choosePhoto() {
      presentPhotoPicker(sourceType: .photoLibrary)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
      let picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = sourceType
      present(picker, animated: true)
        hideResultView()
    }
    
    //从bundle里面懒加载训练的model
    lazy var classificationRequest: VNCoreMLRequest = {
        guard let visionModel = try? VNCoreMLModel(for: MLModel(contentsOf: MultiSnacks.urlOfModelInThisBundle)) else {
            fatalError("Failed to load Vision ML model.")
        }
        
        //请求 model
        let request = VNCoreMLRequest(model: visionModel) { [unowned self] request, _ in
            self.processObservations(for: request)
        }
        request.imageCropAndScaleOption = .centerCrop
        return request
    }()
    
    //解析请求的结果，解析出识别的label，以及相应的概率
    func processObservations(for request : VNRequest) {
        DispatchQueue.main.async {
            let observations = (request.results! as! [VNClassificationObservation]).prefix(3)
            
            self.resultsLabel.text = observations.map { observation in
                  let formatter = NumberFormatter()
                  formatter.maximumFractionDigits = 1
                  let confidencePercentage = formatter.string(from: observation.confidence * 100 as NSNumber)!
                  return "\(observation.identifier) \(confidencePercentage)%"
            }.joined(separator: "\n")
            self.showResultView()
        }
    }

    //传入图片和图片对应的方向进行请求
    func classify(image : UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            let ciImage = CIImage(image: image)!
            let orientation = CGImagePropertyOrientation(image.imageOrientation)
            let handler = VNImageRequestHandler(ciImage: ciImage,orientation: orientation)
            
            try! handler.perform([self.classificationRequest])
        }
    }

}

extension MachineLearningViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        
        classify(image: image)
    }
}



