//
//  CameraView.swift
//  TrafficLightDetector
//
//  Created by Abraham Gonzalez on 1/7/25.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        if let captureSession = viewModel.captureSession {
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = UIScreen.main.bounds
            view.layer.addSublayer(previewLayer)
        }
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
