//
//  CollectionViewCell.swift
//  ARKitTest
//
//  Created by Artem Balashov on 03/08/2018.
//  Copyright © 2018 Artem Balashov. All rights reserved.
//

import UIKit
import SceneKit
import NVActivityIndicatorView

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var label: UILabel!
    
    lazy var activity: NVActivityIndicatorView = {
        let size: CGFloat = self.frame.size.height / 2
        let frame = CGRect.init(x: self.frame.size.width / 2 - size / 2, y: self.frame.size.height / 2 - size / 2, width: size, height: size)
        return NVActivityIndicatorView.init(frame: frame)
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.textColor = .white
        activity.startAnimating()
        setupScene()
    }
    
    func setupScene(){
        let scene = SceneKitHelper.loadScnNamed(name: "ramps")
        sceneView.scene = scene
        let camera = SCNCamera.init()
        camera.usesOrthographicProjection = true
        scene?.rootNode.camera = camera
    }
    
    override func prepareForReuse() {
        activity.startAnimating()
        setupScene()
    }
    
    func configureWithSceneName(name: String){
        label.text = name.capitalized
        switch name {
        case "pipe":
            let pipe = Ramp.getPipe()
            Ramp.makeRotation(node: pipe)
            sceneView.scene?.rootNode.addChildNode(pipe)
            return
        case "pyramid":
            let pyramid = Ramp.getPyramid()
            Ramp.makeRotation(node: pyramid)
            sceneView.scene?.rootNode.addChildNode(pyramid)
            return
        case "quarter":
            let quarter = Ramp.getQuarter()
            Ramp.makeRotation(node: quarter)
            sceneView.scene?.rootNode.addChildNode(quarter)
            return
        default:
            if let node = SceneKitHelper.getRootNodeNamed(name) {
                node.position = SCNVector3Make(0, 0, 0)
                Ramp.makeRotation(node: node)
                sceneView.scene?.rootNode.addChildNode(node)
                return
            }
        }
        activity.stopAnimating()
    }
}
