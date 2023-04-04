//
//  TyrannosaurusData.swift
//  BigRexRealityKit
//
//  Created by Tiger Nixon on 4/4/23.
//

import Foundation
import RealityKit

class TyrannosaurusData {
    
    private(set) var bodyMeshResources = [MeshResource]()
    private(set) var eyeLeftMeshResources = [MeshResource]()
    private(set) var eyeRightMeshResources = [MeshResource]()
    private(set) var spikesMeshResources = [MeshResource]()
    
    
    init() {
        loadBody()
        loadEyeLeft()
        loadEyeRight()
        loadSpikes()
    }
    
    lazy var bodyResourceColor: TextureResource? = {
        try? TextureResource.load(named: "rex_body_color", in: Bundle.main)
    }()
    
    lazy var bodyResourceNormal: TextureResource? = {
        try? TextureResource.load(named: "rex_body_normal", in: Bundle.main)
    }()
    
    lazy var bodyResourceSpecular: TextureResource? = {
        try? TextureResource.load(named: "rex_body_specular", in: Bundle.main)
    }()
    
    
    lazy var eyeResourceColor: TextureResource? = {
        try? TextureResource.load(named: "rex_eyes_color", in: Bundle.main)
    }()
    
    lazy var eyeResourceNormal: TextureResource? = {
        try? TextureResource.load(named: "rex_eyes_normal", in: Bundle.main)
    }()
    
    lazy var bodyMaterial: PhysicallyBasedMaterial = {
        var result = PhysicallyBasedMaterial()
        
        guard let bodyResourceColor = bodyResourceColor else { return result }
        guard let bodyResourceNormal = bodyResourceNormal else { return result }
        guard let bodyResourceSpecular = bodyResourceSpecular else { return result }
        
        let baseColor = MaterialParameters.Texture(bodyResourceColor)
        result.baseColor = .init(texture: baseColor)
        
        let normal = MaterialParameters.Texture(bodyResourceNormal)
        result.normal = .init(texture: normal)
        
        let specular = MaterialParameters.Texture(bodyResourceSpecular)
        result.specular = .init(texture: specular)
        
        return result
    }()
    
    lazy var eyeMaterial: PhysicallyBasedMaterial = {
        var result = PhysicallyBasedMaterial()
        
        guard let eyeResourceColor = eyeResourceColor else { return result }
        guard let eyeResourceNormal = eyeResourceNormal else { return result }
        
        let baseColor = MaterialParameters.Texture(eyeResourceColor)
        result.baseColor = .init(texture: baseColor)
        
        let normal = MaterialParameters.Texture(eyeResourceNormal)
        result.normal = .init(texture: normal)
        
        return result
    }()
    
    private func loadBody() {
        
        let indices = loadFileAsUInt32(fileName: "rex_body_indices", fileExtension: "dat")
        let textureCoordinates = loadFileAsFloat2(fileName: "rex_body_texturecoordinates", fileExtension: "dat")
        
        var meshDescriptor = MeshDescriptor()
        meshDescriptor.textureCoordinates = MeshBuffers.TextureCoordinates(textureCoordinates)
        meshDescriptor.primitives = .triangles(indices)
        
        for index in 0...40 {
            
            let positions = loadFileAsFloat3(fileName: "rex_body_frame_\(index)_positions", fileExtension: "dat")
            let normals = loadFileAsFloat3(fileName: "rex_body_frame_\(index)_normals", fileExtension: "dat")
            
            meshDescriptor.positions = MeshBuffers.Positions(positions)
            meshDescriptor.normals = MeshBuffers.Normals(normals)
            
            if let meshResource = try? MeshResource.generate(from: [meshDescriptor]) {
                bodyMeshResources.append(meshResource)
            }
        }
    }
    
    private func loadEyeLeft() {
        let indices = loadFileAsUInt32(fileName: "rex_eye_left_indices", fileExtension: "dat")
        let textureCoordinates = loadFileAsFloat2(fileName: "rex_eye_left_texturecoordinates", fileExtension: "dat")
        
        var meshDescriptor = MeshDescriptor()
        meshDescriptor.textureCoordinates = MeshBuffers.TextureCoordinates(textureCoordinates)
        meshDescriptor.primitives = .triangles(indices)
        
        for index in 0...40 {
            
            let positions = loadFileAsFloat3(fileName: "rex_eye_left_frame_\(index)_positions", fileExtension: "dat")
            let normals = loadFileAsFloat3(fileName: "rex_eye_left_frame_\(index)_normals", fileExtension: "dat")
            
            meshDescriptor.positions = MeshBuffers.Positions(positions)
            meshDescriptor.normals = MeshBuffers.Normals(normals)
            
            if let meshResource = try? MeshResource.generate(from: [meshDescriptor]) {
                eyeLeftMeshResources.append(meshResource)
            }
        }
    }
    
    private func loadEyeRight() {
        let indices = loadFileAsUInt32(fileName: "rex_eye_right_indices", fileExtension: "dat")
        let textureCoordinates = loadFileAsFloat2(fileName: "rex_eye_right_texturecoordinates", fileExtension: "dat")
        
        var meshDescriptor = MeshDescriptor()
        meshDescriptor.textureCoordinates = MeshBuffers.TextureCoordinates(textureCoordinates)
        meshDescriptor.primitives = .triangles(indices)
        
        for index in 0...40 {
            
            let positions = loadFileAsFloat3(fileName: "rex_eye_right_frame_\(index)_positions", fileExtension: "dat")
            let normals = loadFileAsFloat3(fileName: "rex_eye_right_frame_\(index)_normals", fileExtension: "dat")
            
            meshDescriptor.positions = MeshBuffers.Positions(positions)
            meshDescriptor.normals = MeshBuffers.Normals(normals)
            
            if let meshResource = try? MeshResource.generate(from: [meshDescriptor]) {
                eyeRightMeshResources.append(meshResource)
            }
        }
    }
    
    private func loadSpikes() {
        let indices = loadFileAsUInt32(fileName: "rex_spikes_indices", fileExtension: "dat")
        let textureCoordinates = loadFileAsFloat2(fileName: "rex_spikes_texturecoordinates", fileExtension: "dat")
        
        var meshDescriptor = MeshDescriptor()
        meshDescriptor.textureCoordinates = MeshBuffers.TextureCoordinates(textureCoordinates)
        meshDescriptor.primitives = .triangles(indices)
        
        for index in 0...40 {
            
            let positions = loadFileAsFloat3(fileName: "rex_spikes_frame_\(index)_positions", fileExtension: "dat")
            let normals = loadFileAsFloat3(fileName: "rex_spikes_frame_\(index)_normals", fileExtension: "dat")
            
            meshDescriptor.positions = MeshBuffers.Positions(positions)
            meshDescriptor.normals = MeshBuffers.Normals(normals)
            
            if let meshResource = try? MeshResource.generate(from: [meshDescriptor]) {
                spikesMeshResources.append(meshResource)
            }
        }
    }
    
    func loadFileAsUInt32(fileName: String, fileExtension: String) -> [UInt32] {
        
        guard let data = load(fileName: fileName, fileExtension: fileExtension) else {
            return [UInt32]()
        }
        
        let indexCount = data.count / (MemoryLayout<UInt32>.size)
        var result = [UInt32](repeating: 0, count: indexCount)
        data.withUnsafeBytes {
            for index in 0..<indexCount {
                let byteOffset = index * MemoryLayout<UInt32>.size
                result[index] = $0.load(fromByteOffset: byteOffset, as: UInt32.self)
            }
        }
        
        return result
    }
    
    func loadFileAsFloat3(fileName: String, fileExtension: String) -> [SIMD3<Float>] {
        
        guard let data = load(fileName: fileName, fileExtension: fileExtension) else {
            return [SIMD3<Float>]()
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
        
        guard let data = load(fileName: fileName, fileExtension: fileExtension) else {
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
        
        let count = floatCount / 2
        var result = [SIMD2<Float>](repeating: SIMD2<Float>(x: 0.0, y: 0.0), count: count)
        for index in 0..<count {
            let floatIndex = index * 2
            
            let u = floats[floatIndex + 0]
            let v = floats[floatIndex + 1]
            
            let vector = SIMD2<Float>(x: u, y: v)
            
            result[index] = vector
        }
        return result
    }
    
    func load(fileName: String, fileExtension: String) -> Data? {
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
