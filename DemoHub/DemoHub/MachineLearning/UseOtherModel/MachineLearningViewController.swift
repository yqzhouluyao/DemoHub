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
    
    //3、该函数首先使用 VNCoreMLModel 加载预训练的机器学习模型，该模型将 Core ML 模型作为输入
    lazy var classificationRequest: VNCoreMLRequest = {
        guard let visionModel = try? VNCoreMLModel(for: MLModel(contentsOf: MultiSnacks.urlOfModelInThisBundle)) else {
            fatalError("Failed to load Vision ML model.")
        }
        
        //4、创建执行 对象识别的请求
        let request = VNCoreMLRequest(model: visionModel) { [unowned self] request, _ in
            self.processObservations(for: request)
        }
        request.imageCropAndScaleOption = .centerCrop
        return request
    }()
    
  
    func processObservations(for request : VNRequest) {
        DispatchQueue.main.async {
            
            //5、该请求配置为返回 VNClassificationObservation 对象，其中包含有关预测对象类及其相关置信度分数的信息。
            //提取前3个预测并将它们返回给完成处理程序，至于为什么提取前3个预测，而不是前5个预测，是考虑到预测结果的精确和性能的平衡，更多的预测结果会降低性能
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
            //2、将UIImage转成CIImage 以供机器学习model 处理
            let ciImage = CIImage(image: image)!
            let orientation = CGImagePropertyOrientation(image.imageOrientation)
            let handler = VNImageRequestHandler(ciImage: ciImage,orientation: orientation)
            //根据输入的图片进行图像识别
            try! handler.perform([self.classificationRequest])
        }
    }

}

extension MachineLearningViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        //1、访问设备的相机或照片库以捕捉或选择图像
        classify(image: image)
    }
}



