//
//  TyrannosaurusEntity.swift
//  BigRexRealityKit
//
//  Created by Tiger Nixon on 4/3/23.
//

import Foundation
import RealityKit

class Tyrannosaurus {
    
    var bodyFrames = [ModelEntity]()
    var eyeLeftFrames = [ModelEntity]()
    var eyeRightFrames = [ModelEntity]()
    var spikesFrames = [ModelEntity]()
    
    var frame: Double = 0.0
    
    let data: TyrannosaurusData
    
    required init(data: TyrannosaurusData) {
        self.data = data
        
        for mesh in data.bodyMeshResources {
            let entity = ModelEntity(mesh: mesh, materials: [data.bodyMaterial])
            bodyFrames.append(entity)
        }
        
        for mesh in data.eyeLeftMeshResources {
            
            let entity = ModelEntity(mesh: mesh, materials: [data.eyeMaterial])
            eyeLeftFrames.append(entity)
        }
        
        for mesh in data.eyeRightMeshResources {
            let entity = ModelEntity(mesh: mesh, materials: [data.eyeMaterial])
            eyeRightFrames.append(entity)
        }
        
        for mesh in data.spikesMeshResources {
            let entity = ModelEntity(mesh: mesh, materials: [data.bodyMaterial])
            spikesFrames.append(entity)
        }
    }
    
    func update(deltaTime: TimeInterval) {
        
        let frameCount = bodyFrames.count
        guard frameCount > 0 else { return }
        
        let frameCountDouble = Double(frameCount)
        
        frame += Double(deltaTime * 30.0)
        while frame > frameCountDouble {
            frame -= frameCountDouble
        }
        
        var frameIndex = Int(frame)
        if frameIndex >= frameCount { frameIndex = frameCount - 1 }
        if frameIndex < 0 { frameIndex = 0 }
        
        for index in 0..<bodyFrames.count {
            if index == frameIndex {
                bodyFrames[index].isEnabled = true
                eyeLeftFrames[index].isEnabled = true
                eyeRightFrames[index].isEnabled = true
                spikesFrames[index].isEnabled = true
            } else {
                bodyFrames[index].isEnabled = false
                eyeLeftFrames[index].isEnabled = false
                eyeRightFrames[index].isEnabled = false
                spikesFrames[index].isEnabled = false
            }
        }
    }
    
}
