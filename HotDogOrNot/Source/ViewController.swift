//
//  ViewController.swift
//  HotDogOrNot
//
//  Created by Mario Vanegas on 9/11/20.
//  Copyright © 2020 vanegasmario. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hotdogView: UIView!
    @IBOutlet weak var noHotdogView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let squeezeNet = SqueezeNet()
            let visionModel = try VNCoreMLModel(for: squeezeNet.model)
            let request = VNCoreMLRequest(model: visionModel, completionHandler: classificationHandler)
            
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Error while loading ML Model: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        setupViews()
    }
    
    @IBAction func performCameraAction(_ sender: Any) {
        presentPhotoPicker(.camera)
    }
    
    private func setupCamera() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    private func setupViews() {
        hotdogView.isHidden = true
        noHotdogView.isHidden = true
    }
    
    private func presentPhotoPicker(_ sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        
        present(picker, animated: true)
    }
    
    private func classificationHandler(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation], let objectDetected = results.first else {
                print("There's no results")
                return
            }
            
            let objectNames = objectDetected.identifier.split(separator: ",")
            
            if objectNames.first == "hotdog" {
                UIView.animate(withDuration: 0.3, animations: { self?.hotdogView.isHidden = false })
            } else {
                UIView.animate(withDuration: 0.3, animations: { self?.noHotdogView.isHidden = false })
            }
        }
    }
    
    private func classify(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            print("Unable to create CIImage")
            return
        }
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification request: \(error.localizedDescription)")
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        
        picker.dismiss(animated: true)
        setupViews()
        classify(image)
    }
}

