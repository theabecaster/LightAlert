//
//  VideoBackgroundView.swift
//  TrafficLightDetector
//
//  Created by Abraham Gonzalez on 1/8/25.
//

import SwiftUI
import AVKit

struct VideoBackgroundView: UIViewRepresentable {
    private let player: AVPlayer

    init(videoName: String, videoType: String) {
        guard let path = Bundle.main.path(forResource: videoName, ofType: videoType) else {
            fatalError("Video not found")
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        player.isMuted = true // Mute the video
        player.actionAtItemEnd = .none // Loop video
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(playerLayer)

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero) // Restart video
            player.play()
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main) { _ in
            player.seek(to: .zero) // Restart video
            player.play()
        }

        player.play()
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
