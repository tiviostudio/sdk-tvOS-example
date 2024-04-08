import SwiftUI
import AVKit
import Tivio

struct PlayerView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel

    private let player = AVPlayer()
    private var playerController: PlayerController {
        return PlayerController(player: self.player)
    }

    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                updatePlayerChannel()
            }
            .onChange(of: playerViewModel.channel) { newChannel in
                updatePlayerChannel()
            }
            .onDisappear {
                self.playerViewModel.shouldPlay = false
                self.player.replaceCurrentItem(with: nil)
            }
    }

    private func updatePlayerChannel() {
        if player.currentItem == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          
            self.playerController.playerWrapper.setSource(TivioPlayerSource(
                channel: playerViewModel.channel,
                mode: "live",
                uri: "",
                epgFrom: UInt(Date().timeIntervalSince1970) * 1000,
                epgTo: UInt(Date().timeIntervalSince1970) * 1000,
                streamStart: UInt(Date().timeIntervalSince1970) * 1000,
                startFromPosition: 0
            ), calibrationId: "default")
        }
    }
}
