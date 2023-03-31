//
//  TouchHandlerView.swift
//  BigRexRealityKit
//
//  Created by Tiger Nixon on 3/29/23.
//

import UIKit
import ARKit
import RealityKit
import simd

class TouchHandlerView: UIView {
    
    
    private let textureBodyDiffuse = UIImage(named: "rex_body_diffuse")
    private let textureBodyNormal = UIImage(named: "rex_body_normal")
    private let textureBodySpecular = UIImage(named: "rex_body_specular")
    
    private let textureEyeDiffuse = UIImage(named: "rex_eyes_diffuse")
    private let textureEyeNormal = UIImage(named: "rex_eyes_normal")
    
    
    
    let arView: ARView
    required init(arView: ARView) {
        self.arView = arView
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: arView)
            
            let estimatedPlane = ARRaycastQuery.Target.estimatedPlane
            let targetAlignment = ARRaycastQuery.TargetAlignment.horizontal
            //let targetAlignment = ARRaycastQuery.TargetAlignment.vertical
                    
            let result: [ARRaycastResult] = arView.raycast(from: location,
                                                           allowing: estimatedPlane,
                                                           alignment: targetAlignment)
            
            guard let rayCast: ARRaycastResult = result.first
            else { return }
            
            // 1.) The anchor
            let anchor = AnchorEntity(world: rayCast.worldTransform)
            
            
            // 2.) The model/entity
            
            //let meshers =
            
            
            
            
            guard let colorResource = try? TextureResource.load(named: "rex_body_color", in: Bundle.main) else {
                return
            }
            
            guard let normalResource = try? TextureResource.load(named: "rex_body_normal", in: Bundle.main) else {
                return
            }
            
            guard let specularResource = try? TextureResource.load(named: "rex_body_specular", in: Bundle.main) else {
                return
            }
            
            do {
                let displacementResource = try TextureResource.load(named: "rex_body_displacement", in: Bundle.main)
                
                
            } catch let error {
                print("error: \(error.localizedDescription)")
            }
            
            
            
            /*
            else if let resourceFileName = baseColor, let resource = try? TextureResource.load(named: resourceFileName) {
                        let baseColor = MaterialParameters.Texture(resource)
                        material.baseColor = PhysicallyBasedMaterial.BaseColor(texture: baseColor)
                    }
            */
            
            
            var descr = MeshDescriptor(name: "tritri")
            
            let areGeeBee = loadFileAsFloat3(fileName: "rex_body_frame_4_vertices", fileExtension: "dat")
            descr.positions = MeshBuffers.Positions(areGeeBee)
            
            let youVee = loadFileAsFloat2(fileName: "rex_body_texcoords", fileExtension: "dat")
            descr.textureCoordinates = MeshBuffers.TextureCoordinates(youVee)
            
            let normalll = loadFileAsFloat3(fileName: "rex_body_frame_4_normals", fileExtension: "dat")
            descr.normals = MeshBuffers.Normals(normalll)
            
            
            print("areGeeBee count = \(areGeeBee.count)")
            print("youVee count = \(youVee.count)")
            print("normalll count = \(normalll.count)")
            
            
            
            
            //descr.textureCoordinates
            //descr.normals
            
            let indeces = loadFileAsUInt32(fileName: "rex_body_indices", fileExtension: "dat")
            
            descr.primitives = .triangles(indeces)
            
            //var material = PhysicallyBasedMaterial()
            
            /*
            //let baseColor = MaterialParameters.Texture(diffuseResource)
            let baseColor = CustomMaterial.BaseColor.init(texture: diffuseResource)
            material.baseColor = PhysicallyBasedMaterial.BaseColor(baseColor)
            */
            
            /*
            var material = SimpleMaterial()
            let baseColor = MaterialParameters.Texture(colorResource)
            material.color = .init(texture: baseColor)
              */
            
            var material = PhysicallyBasedMaterial()
            let baseColor = MaterialParameters.Texture(colorResource)
            material.baseColor = .init(texture: baseColor)
            
            
            
            let normal = MaterialParameters.Texture(normalResource)
            material.normal = .init(texture: normal)
            
            
            let specular = MaterialParameters.Texture(specularResource)
            material.specular = .init(texture: specular)
            
            
            
            let generatedModel = ModelEntity(
               mesh: try! .generate(from: [descr]),
              // materials: [SimpleMaterial(color: .orange, isMetallic: false)]
               materials: [material]
            )
            
            generatedModel.scale = SIMD3<Float>(x: 0.025, y: 0.025, z: 0.025)
            
            /*
            let sphere = MeshResource.generateSphere(radius: 0.05)
            let material = SimpleMaterial(color: .red, isMetallic: true)
            let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
             */
            
            //rex_body_frame_4_vertices.dat
            
            
            // 3.) Attach the entity to the anchor
            anchor.addChild(generatedModel)
            
            
            
            // 4.) Attach the anchor to the scene
            arView.scene.anchors.append(anchor)
            
            print(rayCast)
            
        }
    }
    
    /*
    
    
    func loadFileAsInt16() -> [Int16] {
        
    }
    
    
    */
    
    /*
    
    
    private func readFloat32() -> Float32? {
        guard (cursor >= 0) && ((cursor + 4) <= bytes.count) else { return nil }
        let result = bytes.withUnsafeBytes {
            $0.load(fromByteOffset: cursor, as: Float32.self)
        }
        cursor += 4
        return result
    }

    private func readInt32() -> Int32? {
        guard (cursor >= 0) && ((cursor + 4) <= bytes.count) else { return nil }
        let result = bytes.withUnsafeBytes {
            $0.load(fromByteOffset: cursor, as: Int32.self)
        }
        cursor += 4
        return result
    }
    
    
    */
    
    /*
    private func readInt32() -> Int32? {
        guard (cursor >= 0) && ((cursor + 4) <= bytes.count) else { return nil }
        let result = bytes.withUnsafeBytes {
            $0.load(fromByteOffset: cursor, as: Int32.self)
        }
        cursor += 4
        return result
    }
    */
    
    func loadFileAsUInt32(fileName: String, fileExtension: String) -> [UInt32] {
        
        guard let data = Self.load(fileName: fileName, fileExtension: fileExtension) else {
            return [UInt32]()
        }
        
        let indexCount = data.count / (MemoryLayout<Int16>.size)
        var indices = [Int16](repeating: 0, count: indexCount)
        data.withUnsafeBytes {
            for index in 0..<indexCount {
                let byteOffset = index * MemoryLayout<Int16>.size
                indices[index] = $0.load(fromByteOffset: byteOffset, as: Int16.self)
            }
        }
        
        var result = [UInt32](repeating: 0, count: indexCount)
        for index in 0..<indices.count {
            result[index] = UInt32(indices[index])
        }
        
        return result
    }
    
    func loadFileAsFloat3(fileName: String, fileExtension: String) -> [SIMD3<Float>] {
        
        guard let data = Self.load(fileName: fileName, fileExtension: fileExtension) else {
            return [SIMD3<Float>]()
        }
        
        let floatCount = data.count / (MemoryLayout<Float>.size)
        var floats = [Float](repeating: 0.0, count: floatCount)
        data.withUnsafeBytes {
            //$0.load( as: Float.self)
            for index in 0..<floatCount {
                let byteOffset = index * MemoryLayout<Float>.size
                floats[index] = $0.load(fromByteOffset: byteOffset, as: Float.self)
            }
        }
        
        let count = floatCount / 3
        var result = [SIMD3<Float>](repeating: SIMD3<Float>(x: 0.0, y: 0.0, z: 0.0), count: count)
        for index in 0..<count {
            let floatIndex = index * 3
            
            let x = floats[floatIndex + 0]
            let y = floats[floatIndex + 1]
            let z = floats[floatIndex + 2]
            
            let vector = SIMD3<Float>(x: x, y: y, z: z)
            
            result[index] = vector
        }
        return result
    }
    
    func loadFileAsFloat2(fileName: String, fileExtension: String) -> [SIMD2<Float>] {
        
        guard let data = Self.load(fileName: fileName, fileExtension: fileExtension) else {
            return [SIMD2<Float>]()
        }
        
        let floatCount = data.count / (MemoryLayout<Float>.size)
        var floats = [Float](repeating: 0.0, count: floatCount)
        data.withUnsafeBytes {
            for index in 0..<floatCount {
                let byteOffset = index * MemoryLayout<Float>.size
                floats[index] = $0.load(fromByteOffset: byteOffset, as: Float.self)
            }
        }
        
        let count = floatCount / 3
        var result = [SIMD2<Float>](repeating: SIMD2<Float>(x: 0.0, y: 0.0), count: count)
        for index in 0..<count {
            let floatIndex = index * 3
            
            let u = floats[floatIndex + 0]
            let v = 1.0 - floats[floatIndex + 1]
            
            let vector = SIMD2<Float>(x: u, y: v)
            
            result[index] = vector
        }
        return result
    }
    
    static func load(fileName: String, fileExtension: String) -> Data? {
        let bundle = Bundle.main
        guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            print("Could not find URL for \(fileName) of type .\(fileExtension)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch let error {
            print("Error Loading: \(fileName) of type .\(fileExtension)")
            print("\(error.localizedDescription)")
            return nil
        }
    }

}

