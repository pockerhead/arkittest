//
//  RampPickerVC.swift
//  ARKitTest
//
//  Created by Artem Balashov on 02/08/2018.
//  Copyright © 2018 Artem Balashov. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController {

    var sceneView: SCNView!
    var size: CGSize!
    var completion: ((String) -> Void)?
    
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect.init(origin: CGPoint.zero, size: size)
        view.frame = frame
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapHandler(_:)))
        view.addGestureRecognizer(tap)
        sceneView = SCNView(frame: frame)
        view.insertSubview(sceneView, at: 0)
        preferredContentSize = size
        let scene = SceneKitHelper.loadScnNamed(name: "ramps")
        sceneView.scene = scene
        let camera = SCNCamera.init()
        camera.usesOrthographicProjection = true
        scene?.rootNode.camera = camera
        

        
        let pipe = Ramp.getPipe()
        Ramp.makeRotation(node: pipe)
        scene?.rootNode.addChildNode(pipe)
        
        let pyramid = Ramp.getPyramid()
        Ramp.makeRotation(node: pyramid)
        scene?.rootNode.addChildNode(pyramid)
        
        let quarter = Ramp.getQuarter()
        Ramp.makeRotation(node: quarter)
        scene?.rootNode.addChildNode(quarter)
    }

    @objc func tapHandler(_ sender: UITapGestureRecognizer){
        let p = sender.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        
        if hitResults.count > 0, let name = hitResults[0].node.name  {
            completion?(name)
        }
    }
    
}


