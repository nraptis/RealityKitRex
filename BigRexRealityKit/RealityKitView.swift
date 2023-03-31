//
//  RealityKitView.swift
//  BigRexRealityKit
//
//  Created by Tiger Nixon on 3/29/23.
//

import SwiftUI
import ARKit
import RealityKit

struct RealityKitView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some ARView {
        let arView = ARView()
        
        let arSession = arView.session
        let worldTrackingConfiguration = ARWorldTrackingConfiguration()
        worldTrackingConfiguration.planeDetection = [.vertical, .horizontal]
        arSession.run(worldTrackingConfiguration)
        arView.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
        
        let coachingOverlayView = ARCoachingOverlayView()
        coachingOverlayView.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(coachingOverlayView)
        NSLayoutConstraint.activate([
            coachingOverlayView.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            coachingOverlayView.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            coachingOverlayView.topAnchor.constraint(equalTo: arView.topAnchor),
            coachingOverlayView.bottomAnchor.constraint(equalTo: arView.bottomAnchor)
        ])
        coachingOverlayView.session = arSession
        coachingOverlayView.goal = .horizontalPlane
        
        let touchHandlerView = TouchHandlerView(arView: arView)
        touchHandlerView.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(touchHandlerView)
        NSLayoutConstraint.activate([
            touchHandlerView.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            touchHandlerView.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            touchHandlerView.topAnchor.constraint(equalTo: arView.topAnchor),
            touchHandlerView.bottomAnchor.constraint(equalTo: arView.bottomAnchor)
        ])
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
