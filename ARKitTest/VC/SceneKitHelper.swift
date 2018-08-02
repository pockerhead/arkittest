//
//  SceneKitHelper.swift
//  ARKitTest
//
//  Created by Artem Balashov on 02/08/2018.
//  Copyright © 2018 Artem Balashov. All rights reserved.
//

import Foundation
import SceneKit

class SceneKitHelper {
    private static let folder: String = "art.scnassets/"
    private static let kHighlightingNode = "HighlightingNode"
    
    
    static func loadDaeNamed(name: String) -> SCNScene?{
        return SCNScene.init(named: "\(folder)\(name).dae")
    }
    
    static func loadScnNamed(name: String) -> SCNScene?{
        return SCNScene.init(named: "\(folder)\(name).scn")
    }
    
    class func createLineNode(fromPos origin: SCNVector3, toPos destination: SCNVector3, color: UIColor) -> SCNNode {
        let line = lineFrom(vector: origin, toVector: destination)
        let lineNode = SCNNode(geometry: line)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = color
        line.materials = [planeMaterial]
        
        return lineNode
    }
    
    class func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
    }
    
    
    class func highlightNode(_ node: SCNNode) {
        let (min, max) = node.boundingBox
        let zCoord = node.position.z
        let topLeft = SCNVector3Make(min.x, max.y, zCoord)
        let bottomLeft = SCNVector3Make(min.x, min.y, zCoord)
        let topRight = SCNVector3Make(max.x, max.y, zCoord)
        let bottomRight = SCNVector3Make(max.x, min.y, zCoord)
        
        
        let bottomSide = createLineNode(fromPos: bottomLeft, toPos: bottomRight, color: .yellow)
        let leftSide = createLineNode(fromPos: bottomLeft, toPos: topLeft, color: .yellow)
        let rightSide = createLineNode(fromPos: bottomRight, toPos: topRight, color: .yellow)
        let topSide = createLineNode(fromPos: topLeft, toPos: topRight, color: .yellow)
        
        [bottomSide, leftSide, rightSide, topSide].forEach {
            $0.name = kHighlightingNode // Whatever name you want so you can unhighlight later if needed
            node.addChildNode($0)
        }
    }
    
    class func unhighlightNode(_ node: SCNNode) {
        let highlightningNodes = node.childNodes { (child, stop) -> Bool in
            child.name == kHighlightingNode
        }
        highlightningNodes.forEach {
            $0.removeFromParentNode()
        }
    }
}

class Ramp {
    
    class func getRampForName(name: String) -> SCNNode {
        switch name {
        case "pipe":
            return Ramp.getPipe()
        case "pyramid":
            return Ramp.getPyramid()
        case "quarter":
            return Ramp.getQuarter()
        default:
            return Ramp.getPipe()
        }
    }
    
    class func getPipe() -> SCNNode{
        let obj = SceneKitHelper.loadDaeNamed(name: "pipe")
        let node = obj?.rootNode.childNode(withName: "pipe", recursively: true)!
        node?.scale = SCNVector3Make(0.0052, 0.0052, 0.0052)
        node?.position = SCNVector3Make(-1, 5.6, -1)
        return node!
    }
    
    class func getPyramid() -> SCNNode{
        let obj = SceneKitHelper.loadDaeNamed(name: "pyramid")
        let node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)!
        node?.scale = SCNVector3Make(0.018, 0.018, 0.018)
        node?.position = SCNVector3Make(-1, 2.5, -1)
        return node!
    }
    
    class func getQuarter() -> SCNNode{
        let obj = SceneKitHelper.loadDaeNamed(name: "quarter")
        let node = obj?.rootNode.childNode(withName: "quarter", recursively: true)!
        node?.scale = SCNVector3Make(0.018, 0.018, 0.018)
        node?.position = SCNVector3Make(-1, -1.5, -1)
        return node!
    }
    
    class func makeRotation(node: SCNNode){
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1)
        let rotateAction = SCNAction.repeatForever(action)
        node.runAction(rotateAction)
    }
}