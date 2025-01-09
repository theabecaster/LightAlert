//
//  CameraViewModel.swift
//  TrafficLightDetector
//
//  Created by Abraham Gonzalez on 1/7/25.
//

import AVFoundation
import Combine
import CoreML
import Vision
import CoreHaptics

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    // Published properties for SwiftUI updates
    @Published var detectionState: DetectionState = .unknown

    var captureSession: AVCaptureSession?
    private var cameraOutput: AVCaptureVideoDataOutput?
    private let detectionQueue = DispatchQueue(label: "DetectionQueue")
    
    private var predictionHistory: [DetectionState] = []
    private var redStateDuration: TimeInterval = 0
    
    private var lastState: DetectionState = .unknown
    private var hapticEngine: CHHapticEngine?

    private var audioPlayer: AVAudioPlayer?
    
    private var lastUpdateTimestamp: Date?

    // Core ML model
    private lazy var visionModel: VNCoreMLModel? = {
        try? VNCoreMLModel(for: TrafficLightClassifier().model)
    }()

    override init() {
        super.init()
        setupCamera()
        prepareHaptics()
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Error: Unable to access camera.")
            return
        }

        captureSession?.addInput(videoInput)

        cameraOutput = AVCaptureVideoDataOutput()
        cameraOutput?.setSampleBufferDelegate(self, queue: detectionQueue)

        if let output = cameraOutput {
            captureSession?.addOutput(output)
        }
        
        startCapturing()
    }
    
    func startCapturing() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let model = visionModel else { return }

        let request = VNCoreMLRequest(model: model) { [weak self] request, _ in
            self?.handleDetectionResult(request.results as? [VNClassificationObservation])
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
    
    private func handleDetectionResult(_ results: [VNClassificationObservation]?) {
        guard let topResult = results?.sorted(by: { $0.confidence > $1.confidence }).first else {
            throttledUpdateDetectionState(.unknown)
            return
        }
        
        let state: DetectionState
        
        if topResult.confidence < 0.93 {
            state = .unknown
        } else {
            state = DetectionState(rawValue: topResult.identifier) ?? .unknown
        }
        
        handleStateTransition(to: state)
    }
    
    private func handleStateTransition(to newState: DetectionState) {
        if lastState == .red, newState == .green {
            notifyGreenAfterRed()
        }
        
        lastState = newState
        throttledUpdateDetectionState(newState)
    }
    
    private func throttledUpdateDetectionState(_ state: DetectionState) {
        let now = Date()
        
        if let lastUpdate = lastUpdateTimestamp, now.timeIntervalSince(lastUpdate) < 0.7 {
            return
        }
        
        lastUpdateTimestamp = now
        updateDetectionState(state)
    }

    private func notifyGreenAfterRed() {
        playSound(for: .green)
        triggerHapticFeedback()
    }

    private func updateDetectionState(_ state: DetectionState) {
        DispatchQueue.main.async {
            self.detectionState = state
        }
    }

    func stopCamera() {
        captureSession?.stopRunning()
    }
}

// MARK: - Sound and Haptic Feedback
extension CameraViewModel {
    private func playSound(for state: DetectionState) {
        guard state == .green else { return }
        if let soundURL = Bundle.main.url(forResource: "ding", withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        }
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Error starting haptic engine: \(error.localizedDescription)")
        }
    }

    private func triggerHapticFeedback() {
        guard let hapticEngine = hapticEngine else { return }

        let hapticPattern = try? CHHapticPattern(events: [
            CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0),
            CHHapticEvent(eventType: .hapticContinuous, parameters: [], relativeTime: 0.1, duration: 0.3)
        ], parameters: [])

        if let pattern = hapticPattern {
            do {
                let player = try hapticEngine.makePlayer(with: pattern)
                try player.start(atTime: 0)
            } catch {
                print("Error playing haptic feedback: \(error.localizedDescription)")
            }
        }
    }
}
