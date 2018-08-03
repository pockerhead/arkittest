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
    private static let folder: String = "art.scnassets"
    private static let kHighlightingNode = "HighlightingNode"
    
    static func loadDaeNamed(name: String) -> SCNScene?{
        return SCNScene.init(named: "\(folder)/\(name).dae")
    }
    
    static func loadScnNamed(name: String) -> SCNScene?{
        return SCNScene.init(named: "\(folder)/\(name).scn")
    }
    
    static func getRootNodeNamed(_ name: String) -> SCNNode?{
        if let obj = SceneKitHelper.loadDaeNamed(name: name) {
            return obj.rootNode
        } else if let obj = SceneKitHelper.loadScnNamed(name: name) {
            return obj.rootNode
        } else {
            return nil
        }
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


