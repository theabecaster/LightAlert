//
//  ContentView.swift
//  TrafficLightDetector
//
//  Created by Abraham Gonzalez on 1/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
            
            Button(action: {
                viewModel.stopCamera()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Stop")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
