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

    @IBOutlet var RootView: UIView!
    
    @IBOutlet weak var scnView: SCNView!
    
    
    var motionManager : CMMotionManager?
    let camerasNode: SCNNode? = SCNNode()
    var cameraRollNode : SCNNode?
    var cameraPitchNode : SCNNode?
    var cameraYawNode : SCNNode?
    
    var boxNode: SCNNode?
    var tapTextNode: SCNNode?
    
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
        
        scnView!.scene = scene
        //scnView.autoenablesDefaultLighting = true
        
        //Add camera to scene.
        let camera = SCNCamera()
        camera.xFov = 45
        camera.yFov = 45
        
        self.camerasNode!.camera = camera
        self.camerasNode!.position = SCNVector3(x: 0, y: 0, z: 0)
        // The user will be holding their device up (i.e. 90 degrees roll from a flat orientation)
        // so roll the camera by -90 degrees to orient the view correctly
        // otherwise the object will be created "below" the user
        camerasNode!.eulerAngles = SCNVector3Make(degreesToRadians(-90.0), 0, 0)
        
        let cameraRollNode = SCNNode()
        cameraRollNode.addChildNode(camerasNode!)
        
        let cameraPitchNode = SCNNode()
        cameraPitchNode.addChildNode(cameraRollNode)
        
        let cameraYawNode = SCNNode()
        cameraYawNode.addChildNode(cameraPitchNode)
        
        scene.rootNode.addChildNode(cameraYawNode)
        
        scnView!.pointOfView = camerasNode
        
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
        diffuseLightNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(diffuseLightNode)
        
//        let textFront = SCNText(string: "这是前面", extrusionDepth: 0.0)
//        textFront.font = UIFont(name: "Arial", size: 2)
//        let textFrontNode = SCNNode(geometry: textFront)
//        textFrontNode.position = SCNVector3(0, 0, -15)
        
//        let planesTop = SCNPlane(width: 20, height: 20)
//        planesTop.firstMaterial!.doubleSided = true
//        planesTop.firstMaterial!.diffuse.contents = UIColor.blueColor()
//        let planesTopNode = SCNNode(geometry: planesTop)
//        //planesTopNode.pivot = SCNMatrix4MakeRotation(Float(M_PI_2), 1, 0, 0)
//        planesTopNode.eulerAngles = SCNVector3(GLKMathDegreesToRadians(90), 0, 0)
//        planesTopNode.position = SCNVector3(x: 0, y: 10, z: 0)
        
        createItemNode(5, height: 10, imageName: "bgItem1", position: SCNVector3(10, 5, -10), angle: SCNVector3(0, GLKMathDegreesToRadians(-30), 0), scene: scene)
        createItemNode(10, height: 10, imageName: "bgItem2", position: SCNVector3(15, 10, 0), angle: SCNVector3(0, GLKMathDegreesToRadians(-90), 0), scene: scene)
        createItemNode(10, height: 10, imageName: "bgItem3", position: SCNVector3(15, 0, 10), angle: SCNVector3(0, GLKMathDegreesToRadians(-120), 0), scene: scene)
        createItemNode(10, height: 10, imageName: "bgItem4", position: SCNVector3(-15, 0, 0), angle: SCNVector3(0, GLKMathDegreesToRadians(90), 0), scene: scene)
        createItemNode(10, height: 10, imageName: "bgItem5", position: SCNVector3(-15, 0, 10), angle: SCNVector3(0, GLKMathDegreesToRadians(120), 0), scene: scene)
        createItemNode(10, height: 10, imageName: "bgItem6", position: SCNVector3(0, 0, 15), angle: SCNVector3(0, GLKMathDegreesToRadians(180), 0), scene: scene)
        createItemNode(10, height: 15, imageName: "UFO", position: SCNVector3(10, 0, -15), angle: SCNVector3(0, GLKMathDegreesToRadians(-45), 0), scene: scene)
        createItemNode(10, height: 10, imageName: "guitar", position: SCNVector3(-5, 5, -15), angle: nil, scene: scene)
        createItemNode(10, height: 10, imageName: "boon", position: SCNVector3(-10, 5, 0), angle: SCNVector3(0, GLKMathDegreesToRadians(90), 0), scene: scene)
        
        
        let meteor = SCNPlane(width: 10, height: 5)
        meteor.firstMaterial!.diffuse.contents = UIImage(named: "meteor")
        let meteorNode = SCNNode(geometry: meteor)
        meteorNode.position = SCNVector3(0, 10, -10)
        scene.rootNode.addChildNode(meteorNode)
        
        
        // rotation fire meteor
        // the meteor parent node
        let meteorParentNode = SCNNode()
        meteorParentNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(meteorParentNode)
        
        // the meteor rotation node (the center of rotation of the earth around the sun)
        let earthRotationNode = SCNNode()
        meteorParentNode.addChildNode(earthRotationNode)
        
        // the meteor node
        let fireMeteor = SCNPlane(width: 10, height: 2)
        fireMeteor.firstMaterial!.diffuse.contents = UIImage(named: "bgItem7")
        let fireMeteorNode = SCNNode(geometry: fireMeteor)
        fireMeteorNode.position = SCNVector3(-5, 1, -20)
        //fireMeteorNode.eulerAngles = SCNVector3(0, GLKMathDegreesToRadians(145), 0)
        earthRotationNode.addChildNode(fireMeteorNode)
        
        // rotate the Earth and the Sun
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 10.0
        animation.toValue = NSValue(SCNVector4: SCNVector4(0, -1, 0, M_PI*2))
        animation.repeatCount = FLT_MAX
        earthRotationNode.addAnimation(animation, forKey: "earth rotation around sun")
        
        
        // sky 
//        let skytext = MDLTexture(named: "skybox")
//        
//        let skyNode = SCNNode()
        //self.scnView.scene!.background.contents = [UIImage(named: "warlock")!,UIImage(named: "warlock")!,UIImage(named: "warlock")!,UIImage(named: "warlock")!,UIImage(named: "warlock")!,UIImage(named: "warlock")!] as NSArray
        self.scnView!.scene!.background.contents = UIImage(named: "skybox")
        
        // floor
        let floorNode = makeFloor()
        floorNode.position = SCNVector3(x: 0, y: -20, z: 0)
        scene.rootNode.addChildNode(floorNode)
        
        
        // add node from another scene
        // add .scn file
        //let scene1 = SCNScene(named: "art.scnassets/ship.scn")!
        //scene.rootNode.addChildNode(scene1.rootNode.childNodeWithName("ship", recursively: true)!)

        let t90 = SCNScene(named: "art.scnassets/t90.scn")!
        let t90Node = t90.rootNode.childNodeWithName("T-90 reference", recursively: true)!
        scene.rootNode.addChildNode(t90Node)
        
        
        
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
                
                //according to documentation, SCNVector3 from a node is, (pitch, yaw, node)
                cameraRollNode.eulerAngles = SCNVector3Make(0.0, 0.0, -roll)
                cameraPitchNode.eulerAngles = SCNVector3Make(pitch, 0.0, 0.0)
                cameraYawNode.eulerAngles = SCNVector3Make(0.0, yaw, 0.0)
        })
    
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.addTarget(self, action: "tapHandle:")
        self.scnView!.addGestureRecognizer(tapGesture)
        
        meteorAction(meteorNode)
    }
    
    func degreesToRadians(degrees: Float) -> Float {
        return (degrees * Float(M_PI)) / 180.0
    }
    
    func radiansToDegrees(radians: Float) -> Float {
        return (180.0/Float(M_PI)) * radians
    }
    
    func meteorAction(meteor: SCNNode) {
        let action = SCNAction.moveByX(-30, y: -15, z: 0, duration: 8)
        //meteor.runAction(SCNAction.repeatActionForever(action))\
        meteor.runAction(action)
    }
    
//    func fireMeteorAction(meteor: SCNNode) {
////        let frontToRight = SCNAction.moveTo(SCNVector3(15, 9, 0), duration: 5)
////        let rightToBehind = SCNAction.moveTo(SCNVector3(0, 9, 15), duration: 5)
////        let behindToLeft = SCNAction.moveTo(SCNVector3(-15, 9, 0), duration: 5)
////        let leftToFront = SCNAction.moveTo(SCNVector3(0, 9, -15), duration: 5)
//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.values = [
//            NSValue(SCNVector3: SCNVector3(0, 0, -15)),
//            NSValue(SCNVector3: SCNVector3(15, 0, 0)),
//            NSValue(SCNVector3: SCNVector3(0, 0, 15)),
//            NSValue(SCNVector3: SCNVector3(-15, 0, 0)),
//        ]
//        animation.duration = 15
//        meteor.addAnimation(animation, forKey: "orbit")
//    }
    
    func createItemNode(width: CGFloat, height: CGFloat, imageName: String, position: SCNVector3, angle: SCNVector3?, scene: SCNScene) {
        let itemPlane = SCNPlane(width: width, height: height)
        itemPlane.firstMaterial!.diffuse.contents = UIImage(named: imageName)
        let itemNode = SCNNode(geometry: itemPlane)
        itemNode.position = position
        if angle != nil {
            itemNode.eulerAngles = angle!
        }
        scene.rootNode.addChildNode(itemNode)
    }
    
    func tapHandle(recognizer: UITapGestureRecognizer) {
//        let location = recognizer.locationInView(self.scnView)
//        
//        let hitResults = scnView.hitTest(location, options: nil)
//        if hitResults.count > 0 {
//            let hitedNode =  hitResults[0].node
//            if hitedNode == self.boxNode {
//                SCNTransaction.begin()
//                SCNTransaction.setAnimationDuration(0.5)
//                
//                let material = hitedNode.geometry?.firstMaterial
//                if material?.diffuse.contents as! UIColor == UIColor.purpleColor() {
//                    material?.diffuse.contents = UIColor.redColor()
//                } else {
//                    material?.diffuse.contents = UIColor.purpleColor()
//                }
//                
//                SCNTransaction.commit()
//                
//                let action = SCNAction.moveByX(0, y: -0.5, z: 0, duration: 0.5)
//                hitedNode.runAction(action)
//            } else if hitedNode == self.tapTextNode {
//                let camerasAction = SCNAction.moveTo(SCNVector3(15, 10, 0), duration: 0.5)
//                self.camerasNode!.runAction(camerasAction, completionHandler: { () -> Void in
//                    self.performSegueWithIdentifier("Show New Page", sender: self)
//                })
//            }
//        }
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
    
    
    func makeFloor() -> SCNNode {
        let floor = SCNFloor()
        floor.reflectivity = 0
        floor.firstMaterial!.diffuse.contents = UIImage(named: "ground")
        let floorNode = SCNNode()
        floorNode.geometry = floor
//        let floorMaterial = SCNMaterial()
        //floorMaterial.litPerPixel = false
//        floorMaterial.diffuse.contents = UIImage(named:"ground")
//        floorMaterial.diffuse.wrapS = SCNWrapMode.Repeat
//        floorMaterial.diffuse.wrapT = SCNWrapMode.Repeat
//        floor.materials = [floorMaterial]
        return floorNode
    }
    
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
    
    // nav 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show New Page" {
            
        }
    }

}
