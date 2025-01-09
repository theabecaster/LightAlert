//
//  WelcomeViewModel.swift
//  TrafficLightDetector
//
//  Created by Abraham Gonzalez on 1/9/25.
//

import Combine
import AVFoundation

class WelcomeViewModel: ObservableObject {
    @Published var cameraAccessGranted: Bool?
    
    init() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            cameraAccessGranted = nil
        case .restricted, .denied:
            cameraAccessGranted = false
        case .authorized:
            cameraAccessGranted = true
        default:
            cameraAccessGranted = false
        }
        
        requestAccessToCamera()
    }
    
    private func requestAccessToCamera() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraAccessGranted = granted
            }
        }
    }
}
