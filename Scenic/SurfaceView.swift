//
//  SceneView.swift
//  Scenic
//
//  Created by Nick Twyman on 1/22/24.
//

import SwiftUI
import SceneKit

func loadScene(_ model: ScenicModel) -> SCNScene {

    let s=SCNScene()
    
    let camera = SCNCamera()
    camera.usesOrthographicProjection = false
    camera.zNear = 1
    camera.zFar = 100
    let cameraNode = SCNNode()
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 25)
    cameraNode.camera = camera
    
    let cameraOrbit = SCNNode()
    cameraOrbit.addChildNode(cameraNode)
    s.rootNode.addChildNode(cameraOrbit)
    
    cameraOrbit.eulerAngles.x -= CGFloat(Double.pi/8)
    cameraOrbit.eulerAngles.y -= CGFloat(5*Double.pi/4)
    // cameraOrbit.eulerAngles.z -= CGFloat(Double.pi/8)
    
    let mattBlack = SCNMaterial()
    mattBlack.transparency = CGFloat(0.9)
    mattBlack.diffuse.contents = NSColor.black

    let axisGeometry = SCNBox(width: 0.1, height: 0.1, length: 25, chamferRadius: 0)
    axisGeometry.materials = [mattBlack]
    let axisX = SCNNode(geometry: axisGeometry)
    s.rootNode.addChildNode(axisX)
    
    let axisY = SCNNode(geometry: axisGeometry)
    axisY.eulerAngles.y = CGFloat(Double.pi/2)
    s.rootNode.addChildNode(axisY)
    
    let axisZ = SCNNode(geometry: axisGeometry)
    axisZ.eulerAngles.x = CGFloat(Double.pi/2)
    s.rootNode.addChildNode(axisZ)
  
    
    var verts: [SCNVector3] = []
    for y in -10...10 {
        for x in -10...10 {
            let z = model.getZ(x: x, y: y)
            verts.append(SCNVector3(x: CGFloat(x), y: z, z: CGFloat(y)))
        }
    }

    let source = SCNGeometrySource(vertices: verts)
    let widthStride:UInt16 = 21
    var elements:[SCNGeometryElement] = []

    for y in UInt16(0)..<20
    {
        var indices:[UInt16] = []
        let base = y * 21
        for x:UInt16 in base..<base+21 {
            indices.append(x)
            indices.append(x + widthStride)
        }
        elements.append(SCNGeometryElement(indices: indices, primitiveType: .triangleStrip))
    }

    let geom = SCNGeometry(sources: [source], elements: elements)
    let mat1 = SCNMaterial()
    mat1.transparency = CGFloat(0.95)
    mat1.diffuse.contents = NSColor.red
    mat1.metalness.contents = NSColor.red
    mat1.isDoubleSided = true

    let mat2 = SCNMaterial()
    
    mat2.diffuse.contents = NSColor.blue
    mat2.metalness.contents = NSColor.blue
    mat2.transparency = CGFloat(0.95)
    mat2.isDoubleSided = true
    geom.materials = [mat1, mat2]
    
    let strip = SCNNode(geometry: geom)

    s.rootNode.addChildNode(strip)
    
    return s
}

struct SurfaceView: View {
    @Environment(ScenicModel.self) private var model
   
    var body: some View {
        let myScene = loadScene(model)
        return SceneView(scene: myScene)
    }
}

#Preview {
    SurfaceView().environment(ScenicModel(rangeX: -10...10, rangeY: -10...10))
}
