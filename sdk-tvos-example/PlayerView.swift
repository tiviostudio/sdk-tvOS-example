import SwiftUI
import AVKit
import Tivio

struct PlayerView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel

    private let player = AVPlayer()
    var playerWrapper: TivioPlayerWrapper = Tivio.getPlayerWrapper()
    private var playerController: PlayerController {
      return PlayerController(player: self.player, playerViewModel: playerViewModel, playerWrapper: playerWrapper)
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
            .onChange(of: playerViewModel.markers) { _ in
                updateInterstitialTimeRanges()
            }
            .onDisappear {
                self.playerViewModel.shouldPlayLive = false
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
                epgFrom: Date(),
                epgTo: Date(),
                streamStart: Date(),
                startFromPosition: 0
            ), calibrationId: "default")
        }
    }
  
  private func updateInterstitialTimeRanges(for playerItem: AVPlayerItem? = nil) {
      let item = playerItem ?? player.currentItem
      let adTimestamps = generateInterstitialTimeRanges()
      item?.interstitialTimeRanges = adTimestamps
  }

  private func generateInterstitialTimeRanges() -> [AVInterstitialTimeRange] {
      let markers = playerViewModel.markers
      
      let adMarkers = markers.filter { $0.type == "AD" }
      
      let interstitialTimeRanges = adMarkers.map { marker in
          let fromSeconds = Double(marker.relativeFromMs) / 1000
          let toSeconds = Double(marker.relativeToMs) / 1000
          
          let timeRange = CMTimeRange(
              start: CMTime(seconds: fromSeconds, preferredTimescale: 600),
              duration: CMTime(seconds: toSeconds - fromSeconds, preferredTimescale: 600)
          )
          
          return AVInterstitialTimeRange(timeRange: timeRange)
      }
      
      return interstitialTimeRanges
  }
}
