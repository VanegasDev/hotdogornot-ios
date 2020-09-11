//
//  ViewController.swift
//  HotDogOrNot
//
//  Created by Mario Vanegas on 9/11/20.
//  Copyright © 2020 vanegasmario. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hotdogView: UIView!
    @IBOutlet weak var noHotdogView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    
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
    
    func classify(_ image: UIImage) {
        
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        
        picker.dismiss(animated: true)
        classify(image)
    }
}

