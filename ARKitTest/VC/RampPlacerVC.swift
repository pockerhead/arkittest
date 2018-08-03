//
//  ViewController.swift
//  ARKitTest
//
//  Created by Artem Balashov on 02/08/2018.
//  Copyright © 2018 Artem Balashov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerVC: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    var currentAngleY: Float = 0.0
    
    var selectedNodeName: String?
    var selectedNode: SCNNode? {
        didSet  {
            buttonsStackView.isHidden = selectedNode == nil
            for node in sceneView.scene.rootNode.childNodes{
                SceneKitHelper.unhighlightNode(node)
            }
            if let node = selectedNode {
                SceneKitHelper.highlightNode(node)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.scene = scene
        let gesture1 = UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPress(_:)))
        let gesture2 = UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPress(_:)))
        let gesture3 = UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPress(_:)))
        let gesture4 = UIPinchGestureRecognizer.init(target: self, action: #selector(scaleObject(gesture:)))
        let gesture5 = UIRotationGestureRecognizer.init(target: self, action: #selector(rotateNode(_:)))
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        rotateButton.addGestureRecognizer(gesture1)
        upBtn.addGestureRecognizer(gesture2)
        downBtn.addGestureRecognizer(gesture3)
        sceneView.addGestureRecognizer(gesture4)
        sceneView.addGestureRecognizer(gesture5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func onRampButtonPressed(_ sender: UIButton) {
        let rampPickerVC = RampPickerVC.init(size: CGSize.init(width: 250, height: 500))
        rampPickerVC.modalPresentationStyle = .popover
        self.startAnimating()
        rampPickerVC.popoverPresentationController?.delegate = self
        present(rampPickerVC, animated: true, completion: nil)
        rampPickerVC.popoverPresentationController?.sourceView = sender
        rampPickerVC.popoverPresentationController?.sourceRect = sender.bounds
        rampPickerVC.completion = {[weak self] nodeName in
            guard let `self` = self else { return }
            rampPickerVC.dismiss(animated: true, completion: nil)
            self.selectedNodeName = nodeName
        }
        rampPickerVC.onAppeared = {[weak self] in
            guard let `self` = self else { return }
            self.stopAnimating()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touch.view === self.sceneView else { return }
        if let node = getNodeFromTouch(touch: touch){
            if let selected = self.selectedNode {
                if selected !== node {
                    self.selectedNode = node
                }
                return
            }
            self.selectedNode = node
            return
        } else {
            self.selectedNode = nil
        }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.estimatedHorizontalPlane])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        placeRamp(postiton: hitPosition)
    }
    
    @objc func scaleObject(gesture: UIPinchGestureRecognizer) {
        guard let nodeToScale = selectedNode else { return }
        if gesture.state == .changed {
            let pinchScaleX: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.x))
            let pinchScaleY: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.y))
            let pinchScaleZ: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.z))
            nodeToScale.scale = SCNVector3Make(Float(pinchScaleX), Float(pinchScaleY), Float(pinchScaleZ))
            gesture.scale = 1
        }
        if gesture.state == .ended { }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentTouchPoint = touches.first?.location(in: self.sceneView),
            let hitTest = sceneView.hitTest(currentTouchPoint, types: .estimatedHorizontalPlane).first else { return }
        let worldTransform = hitTest.worldTransform
        let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
        if let selectedNode = selectedNode {
            selectedNode.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
        }
        
    }
    
    @objc func rotateNode(_ gesture: UIRotationGestureRecognizer){
        let rotation = Float(gesture.rotation)
        if gesture.state == .changed, let selectedNode = selectedNode {
            selectedNode.eulerAngles.y = currentAngleY - rotation
        }
        if(gesture.state == .ended), let selectedNode = selectedNode {
            currentAngleY = selectedNode.eulerAngles.y
        }
    }
    
    func getNodeFromTouch(touch: UITouch) -> SCNNode? {
        let result = sceneView.hitTest(touch.location(in: sceneView), options: [:])
        if result.count > 0 {
            let node = result[0].node
            return node
        }
        return nil
    }
    
    func placeRamp(postiton: SCNVector3){
        guard let name = selectedNodeName else {return}
        let ramp = Ramp.getRampForName(name: name)
        ramp.position = postiton
        ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
        selectedNode = ramp
        sceneView.scene.rootNode.addChildNode(ramp)
    }
    
    @IBAction func deleteRampButtonPressed(_ sender: UIButton) {
        if let ramp = selectedNode {
            ramp.removeFromParentNode()
            selectedNode = nil
        }
    }
    
    @objc func onLongPress(_ sender: UILongPressGestureRecognizer){
        guard let ramp = selectedNode else { return }
        if sender.state == .ended{
            ramp.removeAllActions()
        } else if sender.state == .began{
            if sender.view === self.rotateButton {
                let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                ramp.runAction(rotate)
            } else if sender.view === self.upBtn {
                let up = SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(0, 0.08, 0), duration: 0.1))
                ramp.runAction(up)
            } else if sender.view === self.downBtn {
                let down = SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(0, -0.08, 0), duration: 0.1))
                ramp.runAction(down)
            }
        }
    }
}
