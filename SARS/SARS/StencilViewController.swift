//
//  ViewController.swift
//  SARS
//
//  Created by Neil on 2/20/19.
//  Copyright © 2019 Neil Sonnenberg. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class StencilViewController: UIViewController, ARSCNViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let previewImage: UIButton = UIButton()
    let applyStencilButton : UIButton = UIButton()
    
    var currSelectedImage = UIImage(named: "art.scnassets/sun-behind-cloud.png")
    
    @IBOutlet var sceneView: ARSCNView!
    var sunImage = [UIImage(named: "art.scnassets/sun-behind-cloud.png")?.alpha(0.5)]
    var imageHolder = SCNNode(geometry: SCNPlane(width: 100, height: 100))
    
    var alphaSlider : UISlider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scanningPanel = UIImageView()
        scanningPanel.backgroundColor = UIColor(white: 0.33, alpha: 0.6)
        scanningPanel.layer.masksToBounds = true
        scanningPanel.frame = CGRect(x: -2, y: self.sceneView.frame.height - 270, width: 178, height: 50)
        
        scanningPanel.layer.cornerRadius = 10
        
        let scanInfo = UILabel(frame: CGRect(x: 8, y: self.sceneView.frame.height - 268, width: 160, height: 45))
        
        scanInfo.textAlignment = .left
        scanInfo.font = scanInfo.font.withSize(15)
        scanInfo.textColor = UIColor.white
        scanInfo.text = "Scan an Interface!"
        let img = UILabel(frame: CGRect(x: 8, y: self.sceneView.frame.height - 100, width: 160, height: 45))
        img.backgroundColor = UIColor.init(patternImage: sunImage[0]!)
        let scanButton = UIButton(frame: CGRect(x: self.sceneView.frame.width / 2, y: self.sceneView.frame.height - 40, width: 160, height: 45))
        scanButton.backgroundColor = .blue
        scanButton.setTitle("Place Image!", for: UIControl.State.normal)
        scanButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        // Opacity Slider
        alphaSlider = UISlider(frame: CGRect(x: 45, y: 70, width: 310, height: 31))
        alphaSlider.minimumValue = 0
        alphaSlider.maximumValue = 1000
        alphaSlider.isContinuous = true
        alphaSlider.tintColor = UIColor.blue
        alphaSlider.value = 500
        alphaSlider.addTarget(self, action: #selector(StencilViewController.alphaSliderValueDidChange), for: .valueChanged)
        
        // Apply Stencil Button
        applyStencilButton.backgroundColor = UIColor(white: 0.33, alpha: 0.6)
        applyStencilButton.setTitle("Apply", for: .normal)
        applyStencilButton.addTarget(self, action: #selector(self.applyStencil), for: .touchUpInside)
        applyStencilButton.layer.cornerRadius = 20
        applyStencilButton.frame = CGRect(x: (view.bounds.width / 2) - 70, y: self.view.frame.height-84, width: 140, height: 70)
        
        // Preview Image and Image Picker Button
        previewImage.backgroundColor = UIColor(white: 1, alpha: 1)
        previewImage.setImage(currSelectedImage, for: .normal)
        previewImage.addTarget(self, action: #selector(self.openPhotoLibraryButton), for: .touchUpInside)
        previewImage.layer.masksToBounds = true
        previewImage.frame = CGRect(x: 4,
                                    y: self.view.frame.height-84,
                                    width: 70,
                                    height: 70)
        previewImage.layer.cornerRadius = 20
        
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        self.sceneView.addSubview(scanningPanel)
        self.sceneView.addSubview(scanInfo)
        self.sceneView.addSubview(scanButton)
        self.sceneView.addSubview(previewImage)
        self.sceneView.addSubview(applyStencilButton)
        self.sceneView.addSubview(alphaSlider)
    }
    
    @objc func alphaSliderValueDidChange(sender: UISlider!) {
        print("alpha value: \(sender.value)")
        sunImage[0] = UIImage(named: "art.scnassets/sun-behind-cloud.png")?.alpha(CGFloat(sender!.value) / 1000)
        imageHolder.geometry?.firstMaterial?.diffuse.contents = sunImage[0] //UIColor.red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        //1. Check We Have Detected An ARPlaneAnchor
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        //2. Get The Size Of The ARPlaneAnchor
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        
        //3. Create An SCNPlane Which Matches The Size Of The ARPlaneAnchor
        imageHolder = SCNNode(geometry: SCNPlane(width: width, height: height))
        
        //4. Rotate It
        imageHolder.eulerAngles.x = -.pi/2
        
        //5. Set It's Colour To Red
        // imageHolder.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        imageHolder.geometry?.firstMaterial?.diffuse.contents = sunImage[0] //UIColor.red
        
        //4. Add It To Our Node & Thus The Hiearchy
        node.addChildNode(imageHolder)
        
    }
    /*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        return node
    }
    */
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        
        guard let imageToApply = sunImage[0] else {
            return
        }
        imageHolder.geometry?.firstMaterial?.diffuse.contents = imageToApply
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

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
