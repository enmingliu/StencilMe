//
//  ViewController.swift
//  UI Development for SARS
//
//  Created by Neil on 2/27/19.
//  Copyright © 2019 Neil Sonnenberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let previewImage = UIImageView()
        previewImage.backgroundColor = UIColor(white: 0.33, alpha: 0.6)
        previewImage.image = UIImage(named:"pikachu-lineart")
        previewImage.layer.masksToBounds = true
        previewImage.frame = CGRect(x: 2,
                                     y: self.view.frame.height-72,
                                     width: 70,
                                     height: 70)
        previewImage.layer.cornerRadius = 20
        
        let applyStencilButton = UIButton(frame: CGRect(x: (view.bounds.width / 2) - 70, y: self.view.frame.height-72, width: 140, height: 70))
        applyStencilButton.backgroundColor = UIColor(white: 0.33, alpha: 0.6)
        applyStencilButton.setTitle("Apply", for: .normal)
        applyStencilButton.addTarget(self, action: #selector(self.applyStencil), for: .touchUpInside)
        applyStencilButton.layer.cornerRadius = 20
        
        view.addSubview(previewImage)
        view.addSubview(applyStencilButton)
    }

    @IBAction func applyStencil() {
        print("button pressed")
    }

}

