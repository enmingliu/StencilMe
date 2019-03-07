//
//  ViewController.swift
//  UI Development for SARS
//
//  Created by Neil on 2/27/19.
//  Copyright © 2019 Neil Sonnenberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let previewImage : UIButton = UIButton()
    let applyStencilButton : UIButton = UIButton()
    
    var currSelectedImage = UIImage(named:"pikachu-lineart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewImage.backgroundColor = UIColor(white: 1, alpha: 1)
        previewImage.setImage(currSelectedImage, for: .normal)
        previewImage.addTarget(self, action: #selector(self.openPhotoLibraryButton), for: .touchUpInside)
        previewImage.layer.masksToBounds = true
        previewImage.frame = CGRect(x: 4,
                                     y: self.view.frame.height-84,
                                     width: 70,
                                     height: 70)
        previewImage.layer.cornerRadius = 20
        
        applyStencilButton.backgroundColor = UIColor(white: 0.33, alpha: 0.6)
        applyStencilButton.setTitle("Apply", for: .normal)
        applyStencilButton.addTarget(self, action: #selector(self.applyStencil), for: .touchUpInside)
        applyStencilButton.layer.cornerRadius = 20
        applyStencilButton.frame = CGRect(x: (view.bounds.width / 2) - 70, y: self.view.frame.height-84, width: 140, height: 70)
        
        view.addSubview(previewImage)
        view.addSubview(applyStencilButton)
    }

    @IBAction func applyStencil() {
        print("button pressed")
    }
    
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let image = info[.originalImage] as! UIImage
        //let imageData = UIImage.jpegData(image)
        self.previewImage.setImage(image, for: .normal)
        currSelectedImage = image
        self.dismiss(animated: true, completion: nil)
    }
}

