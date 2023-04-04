//
//  TouchHandlerView.swift
//  BigRexRealityKit
//
//  Created by Tiger Nixon on 3/29/23.
//

import UIKit
import ARKit
import RealityKit
import Combine
import simd

class TouchHandlerView: UIView {
    
    let tyrannosaurusData = TyrannosaurusData()
    
    private var updateSubscription: Cancellable?
    
    var dinosaurs = [Tyrannosaurus]()
    
    
    let arView: ARView
    required init(arView: ARView) {
        self.arView = arView
        super.init(frame: .zero)
        
        updateSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { [self] delta in
            for dino in dinosaurs {
                dino.update(deltaTime: delta.deltaTime)
            }
        }
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
            
            let anchor = AnchorEntity(world: rayCast.worldTransform)
            
            let tyrannosaurus = Tyrannosaurus(data: tyrannosaurusData)
            dinosaurs.append(tyrannosaurus)
            tyrannosaurus.update(deltaTime: 0.0)
            
            for entity in tyrannosaurus.bodyFrames {
                anchor.addChild(entity)
            }
            for entity in tyrannosaurus.eyeLeftFrames {
                anchor.addChild(entity)
            }
            for entity in tyrannosaurus.eyeRightFrames {
                anchor.addChild(entity)
            }
            for entity in tyrannosaurus.spikesFrames {
                anchor.addChild(entity)
            }
            
            arView.scene.anchors.append(anchor)
        }
    }
    
}
