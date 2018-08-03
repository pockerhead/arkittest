//
//  Ramp.swift
//  ARKitTest
//
//  Created by Artem Balashov on 03/08/2018.
//  Copyright © 2018 Artem Balashov. All rights reserved.
//

import Foundation
import SceneKit

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
            return SceneKitHelper.getRootNodeNamed(name) ?? Ramp.getPipe()
        }
    }
    
    class func getPipe() -> SCNNode{
        let obj = SceneKitHelper.loadDaeNamed(name: "pipe")
        let node = obj?.rootNode.childNode(withName: "pipe", recursively: true)!
        return node!
    }
    
    class func getPyramid() -> SCNNode{
        let obj = SceneKitHelper.loadDaeNamed(name: "pyramid")
        let node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)!
        return node!
    }
    
    class func getQuarter() -> SCNNode{
        let obj = SceneKitHelper.loadDaeNamed(name: "quarter")
        let node = obj?.rootNode.childNode(withName: "quarter", recursively: true)!
        return node!
    }
    
    class func makeRotation(node: SCNNode){
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1)
        let rotateAction = SCNAction.repeatForever(action)
        node.runAction(rotateAction)
    }
}
