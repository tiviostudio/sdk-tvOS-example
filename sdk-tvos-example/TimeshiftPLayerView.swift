import SwiftUI
import AVKit
import Tivio

struct TimeshiftPlayerView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @EnvironmentObject var programViewModel: ProgramViewModel
  
    var playerWrapper: TivioPlayerWrapper = Tivio.getPlayerWrapper()

    private let player = AVPlayer()
    private var playerController: PlayerController {
      return PlayerController(player: self.player, playerViewModel: playerViewModel, playerWrapper: playerWrapper)
    }

    @State private var currentTime: Double = 0.0
    @State private var duration: Double = 0.0
    @State private var adTimes: [Double] = []
    @State private var isPlayerOnTop: Bool = true
  
    private func updateAdTimes() {
      let markers = playerViewModel.markers.filter { $0.type == "AD" }
      self.adTimes = markers.map { Double($0.relativeFromMs) / 1000 }
    }

    private func seek(to time: Double) {
      print("TivioDebug:seeking Seeking to via button \(time)")
      self.playerController.playerWantsToSeek(to: UInt(time * 1000))
    }

    private func seekBackward() {
      let newTime = max(currentTime - 10, 0)
      seek(to: newTime)
    }
  
  private func setIsPlayerOnTop() {
    isPlayerOnTop.toggle()
    self.playerController.playerOnTop(isPlayerOnTop: isPlayerOnTop)
  }

    private func seekForward() {
      let newTime = min(currentTime + 10, duration)
      seek(to: newTime)
    }

    private func play() {
      player.play()
    }

    private func pause() {
      player.pause()
    }

    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    updatePlayerChannel()
                    addPeriodicTimeObserver()
                }
                .onChange(of: programViewModel.currentProgram.name) { _ in
                    updatePlayerChannel()
                }
                .onChange(of: playerViewModel.markers) { _ in
                    updateInterstitialTimeRanges()
                    updateAdTimes()
                }
                .onDisappear {
                    self.playerViewModel.shouldPlay = false
                    self.player.replaceCurrentItem(with: nil)
                }

            HStack {
                Button(action: seekBackward) {
                    Image(systemName: "gobackward.10")
                        .font(.largeTitle)
                }
                Button(action: play) {
                    Image(systemName: "play.fill")
                        .font(.largeTitle)
                }
                Button(action: pause) {
                    Image(systemName: "pause.fill")
                        .font(.largeTitle)
                }
                Button(action: seekForward) {
                    Image(systemName: "goforward.10")
                        .font(.largeTitle)
                }
              Button(action: setIsPlayerOnTop) {
                Image(systemName: "tv.inset.filled")
                    .font(.largeTitle)
              }
            }
            .padding()

            CustomSeekBar(currentTime: $currentTime, duration: $duration, adTimes: $adTimes, onSeek: seek)
                .frame(height: 20)
                .cornerRadius(10)
                .padding()
        }
    }

    private func updatePlayerChannel() {
        if player.currentItem == nil {
            self.playerController.playerWrapper.setSource(TivioPlayerSource(
                channel: programViewModel.currentProgram.channelName,
                mode: "timeshift",
                uri: "",
                epgFrom: programViewModel.currentProgram.epgFrom,
                epgTo: programViewModel.currentProgram.epgTo,
                streamStart: programViewModel.currentProgram.epgFrom,
                startFromPosition: 0
            ), calibrationId: "default")
        }
    }

    private func updateInterstitialTimeRanges(for playerItem: AVPlayerItem? = nil) {
        let markers = playerViewModel.markers
        let adMarkers = markers.filter { $0.type == "AD" }
        print("TivioDebug: Markers: updateInterstitialTimeRanges", adMarkers.count)
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

            print("TivioDebug: Markers: generateIntestitialTimeRanges", timeRange)
            return AVInterstitialTimeRange(timeRange: timeRange)
        }

        return interstitialTimeRanges
    }

    private func addPeriodicTimeObserver() {
      let timeScale = CMTimeScale(NSEC_PER_SEC)
      player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.05, preferredTimescale: timeScale), queue: .main) { time in
        DispatchQueue.main.async {
          guard let currentItem = self.player.currentItem else { return }
          self.currentTime = CMTimeGetSeconds(time)
          self.duration = CMTimeGetSeconds(currentItem.duration)
        }
      }
    }
}

struct TimeshiftPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        TimeshiftPlayerView()
            .environmentObject(PlayerViewModel())
            .environmentObject(ProgramViewModel())
    }
}
