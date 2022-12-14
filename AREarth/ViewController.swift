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
        

        
//        let rotateAction = SCNAction.rotateBy(x: 0, y: 0.25, z: 0, duration: 2.0)
//
//        // node
//        let node = SCNNode()
//        node.position = SCNVector3(x: 0, y: 0, z: -0.8)
        
//        node.runAction(SCNAction.repeatForever(rotateAction))
        
//        sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return }
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [gridMaterial]

        let planeNode = SCNNode()

        planeNode.geometry = plane
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)

        node.addChildNode(planeNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                
                let sphere = SCNSphere(radius: 0.02)
                let material = SCNMaterial()
                material.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")
                sphere.materials = [material]
                
                let node = SCNNode()
                node.position = SCNVector3(
                                            x: hitResult.worldTransform.columns.3.x,
                                            y: hitResult.worldTransform.columns.3.y + node.boundingSphere.radius*2,
                                            z: hitResult.worldTransform.columns.3.z
                                          )
                node.geometry = sphere
                sceneView.scene.rootNode.addChildNode(node)
                
                let rotateAction = SCNAction.rotateBy(x: 0, y: 0.25, z: 0, duration: 2.0)
                node.runAction(SCNAction.repeatForever(rotateAction))
                
            }
        }
    }


}
