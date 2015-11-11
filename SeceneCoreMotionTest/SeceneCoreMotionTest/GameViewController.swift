//
//  GameViewController.swift
//  SeceneCoreMotionTest
//
//  Created by Rick on 15/11/10.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import CoreMotion

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    
    @IBOutlet var scnView: SCNView!
    
    var motionManager : CMMotionManager?
    var cameraRollNode : SCNNode?
    var cameraPitchNode : SCNNode?
    var cameraYawNode : SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//        
//        // create and add a camera to the scene
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        scene.rootNode.addChildNode(cameraNode)
//        
//        // place the camera
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
//        
//        // create and add a light to the scene
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = SCNLightTypeOmni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode)
//        
//        // create and add an ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = SCNLightTypeAmbient
//        ambientLightNode.light!.color = UIColor.darkGrayColor()
//        scene.rootNode.addChildNode(ambientLightNode)
//        
//        // retrieve the ship node
//        let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
//        
//        // animate the 3d object
//        ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
//        
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//        
//        // set the scene to the view
//        scnView.scene = scene
//        
//        // allows the user to manipulate the camera
//        scnView.allowsCameraControl = true
//        
//        // show statistics such as fps and timing information
//        scnView.showsStatistics = true
//        
//        // configure the view
//        scnView.backgroundColor = UIColor.blackColor()
//        
//        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
//        scnView.addGestureRecognizer(tapGesture)
        
        
        // Create Scene
        let scene = SCNScene()
        
        scnView.scene = scene
        //scnView.autoenablesDefaultLighting = true
        
        //Add camera to scene.
        let camera = SCNCamera()
        camera.xFov = 45
        camera.yFov = 45
        
        let camerasNode = SCNNode()
        camerasNode.camera = camera
        camerasNode.position = SCNVector3(x: 0, y: 0, z: 0)
        // The user will be holding their device up (i.e. 90 degrees roll from a flat orientation)
        // so roll the camera by -90 degrees to orient the view correctly
        // otherwise the object will be created "below" the user
        camerasNode.eulerAngles = SCNVector3Make(degreesToRadians(-90.0), 0, 0)
        
        let cameraRollNode = SCNNode()
        cameraRollNode.addChildNode(camerasNode)
        
        let cameraPitchNode = SCNNode()
        cameraPitchNode.addChildNode(cameraRollNode)
        
        let cameraYawNode = SCNNode()
        cameraYawNode.addChildNode(cameraPitchNode)
        
        scene.rootNode.addChildNode(cameraYawNode)
        
        scnView.pointOfView = camerasNode
        
        // Ambient Light
        let ambientLight = SCNLight()
        ambientLight.type = SCNLightTypeAmbient
        ambientLight.color = UIColor(white: 0.1, alpha: 1.0)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)
        
        // Omni Light
        let diffuseLight = SCNLight()
        diffuseLight.type = SCNLightTypeOmni
        diffuseLight.color = UIColor(white: 1.0, alpha: 1.0)
        let diffuseLightNode = SCNNode()
        diffuseLightNode.light = diffuseLight
        diffuseLightNode.position = SCNVector3(x: -30, y: 30, z: 50)
        scene.rootNode.addChildNode(diffuseLightNode)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.redColor()
        material.locksAmbientWithDiffuse = true
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIColor.whiteColor()
        material2.locksAmbientWithDiffuse = true
        let material3 = SCNMaterial()
        material3.diffuse.contents = UIColor.blueColor()
        material3.locksAmbientWithDiffuse = true
        let material4 = SCNMaterial()
        material4.diffuse.contents = UIColor.purpleColor()
        material4.locksAmbientWithDiffuse = true
        let material5 = SCNMaterial()
        material5.diffuse.contents = UIColor.yellowColor()
        material5.locksAmbientWithDiffuse = true
        let material6 = SCNMaterial()
        material6.diffuse.contents = UIColor.orangeColor()
        material6.locksAmbientWithDiffuse = true
        
        
        //Create the box
        let baseBox = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        
        baseBox.materials = [material2, material2, material3, material4, material5, material6]
        let boxNode = SCNNode(geometry: baseBox)
        boxNode.position = SCNVector3(x: 0, y: -10, z: 0)
        scene.rootNode.addChildNode(boxNode)
        
        
        // Respond to user head movement
        motionManager = CMMotionManager()
        motionManager?.deviceMotionUpdateInterval = 1.0 / 60.0
        
        motionManager?.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical,
            toQueue: NSOperationQueue.mainQueue(),
            withHandler: { (motion: CMDeviceMotion?, error: NSError?) -> Void in
                //self.counter++
                let currentAttitude = motion!.attitude
                let roll = Float(currentAttitude.roll)
                let pitch = Float(currentAttitude.pitch)
                let yaw = Float(currentAttitude.yaw)
                
                //only working at 60FPS on iPhone 6... WHY
                
                //according to documentation, SCNVector3 from a node is, (pitch, yaw, node)
                cameraRollNode.eulerAngles = SCNVector3Make(0.0, 0.0, -roll)
                cameraPitchNode.eulerAngles = SCNVector3Make(pitch, 0.0, 0.0)
                cameraYawNode.eulerAngles = SCNVector3Make(0.0, yaw, 0.0)
        })
    }
    
    func degreesToRadians(degrees: Float) -> Float {
        return (degrees * Float(M_PI)) / 180.0
    }
    
    func radiansToDegrees(radians: Float) -> Float {
        return (180.0/Float(M_PI)) * radians
    }
    
//    func handleTap(gestureRecognize: UIGestureRecognizer) {
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//        
//        // check what nodes are tapped
//        let p = gestureRecognize.locationInView(scnView)
//        let hitResults = scnView.hitTest(p, options: nil)
//        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//            // retrieved the first clicked object
//            let result: AnyObject! = hitResults[0]
//            
//            // get its material
//            let material = result.node!.geometry!.firstMaterial!
//            
//            // highlight it
//            SCNTransaction.begin()
//            SCNTransaction.setAnimationDuration(0.5)
//            
//            // on completion - unhighlight
//            SCNTransaction.setCompletionBlock {
//                SCNTransaction.begin()
//                SCNTransaction.setAnimationDuration(0.5)
//                
//                material.emission.contents = UIColor.blackColor()
//                
//                SCNTransaction.commit()
//            }
//            
//            material.emission.contents = UIColor.redColor()
//            
//            SCNTransaction.commit()
//        }
//    }
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval)
    {
        if let mm = motionManager, let motion = mm.deviceMotion {
            let currentAttitude = motion.attitude
            
            cameraRollNode!.eulerAngles.x = Float(currentAttitude.roll)
            cameraPitchNode!.eulerAngles.z = Float(currentAttitude.pitch)
            cameraYawNode!.eulerAngles.y = Float(currentAttitude.yaw)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
