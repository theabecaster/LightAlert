//
//  DetectionLabelView.swift
//  TrafficLightDetector
//
//  Created by Abraham Gonzalez on 1/7/25.
//

import SwiftUI

struct DetectionLabelView: View {
    var detectionState: DetectionState

    var body: some View {
        Text(detectionStateDescription().uppercased())
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(detectionStateColor())
            .cornerRadius(8)
    }
    
    private func detectionStateDescription() -> String {
        switch detectionState {
        case .red: return "Red"
        case .yellow: return "Yellow"
        case .green: return "Green"
        case .unknown: return "No traffic light detected"
        }
    }


    private func detectionStateColor() -> Color {
        switch detectionState {
        case .red: return .red
        case .yellow: return .yellow
        case .green: return .green
        case .unknown: return .gray
        }
    }
}
