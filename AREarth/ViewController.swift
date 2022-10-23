//
//  ViewController.swift
//  ARDice
//
//  Created by rahul kaushik on 23/10/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
        
        let sphere = SCNSphere(radius: 0.3)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")
        sphere.materials = [material]
        
        let rotateAction = SCNAction.rotateBy(x: 0, y: 0.25, z: 0, duration: 2.0)
        
        // node
        let node = SCNNode()
        node.position = SCNVector3(x: 0, y: 0, z: -0.8)
        node.geometry = sphere
        node.runAction(SCNAction.repeatForever(rotateAction))
        
        sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


}
