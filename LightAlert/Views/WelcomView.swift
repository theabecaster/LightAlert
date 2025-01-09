//
//  WelcomView.swift
//  TrafficLightDetector
//
//  Created by Abraham Gonzalez on 1/8/25.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel: WelcomeViewModel = WelcomeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VideoBackgroundView(videoName: "background", videoType: "mp4")
                    .edgesIgnoringSafeArea(.all)
                
                if viewModel.cameraAccessGranted == false {
                    accessDeniedView
                } else {
                    welcomeView
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    var welcomeView: some View {
        VStack(spacing: 20) {
            Text("Welcome to Traffic Light Detector")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()
                .cornerRadius(10)
                .padding(.top, 50)
            
            Text("""
            Set your device on the dashboard with the camera facing the road. Ensure the traffic lights are visible in the camera's view.
            
            The app will notify you when the light turns green with sound and vibration.
            """)
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding()
            .cornerRadius(10)
            
            Spacer()
            
            NavigationLink(destination: ContentView()) {
                Text("Start Capture")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
    
    var accessDeniedView: some View {
        VStack(spacing: 20) {
            Text("Camera Access Denied")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()
                .cornerRadius(10)
                .padding(.top, 50)
            
            Text("""
                            Camera access is required for the app to function properly. To enable access, please go to your device's Settings, select Light Alert, and allow Camera access.
                            """)
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding()
            .cornerRadius(10)
            
            Spacer()
            
            Button(action: openAppSettings) {
                Text("Open App Settings")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
    
    private func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
}
