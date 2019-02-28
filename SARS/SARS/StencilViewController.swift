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

class StencilViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
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
        
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        self.sceneView.addSubview(scanningPanel)
        self.sceneView.addSubview(scanInfo)
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
        let imageHolder = SCNNode(geometry: SCNPlane(width: width, height: height))
        
        //4. Rotate It
        imageHolder.eulerAngles.x = -.pi/2
        
        //5. Set It's Colour To Red
        imageHolder.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
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
}