import Foundation
import Tivio
import AVFoundation

class PlayerController: TivioPlayerWrapperDelegate {
    
  var player: AVPlayer
  var playerWrapper: TivioPlayerWrapper
  weak var playerViewModel: PlayerViewModel?
  
  init(player: AVPlayer, playerViewModel: PlayerViewModel, playerWrapper: TivioPlayerWrapper) {
    self.player = player
    self.playerViewModel = playerViewModel
    self.playerWrapper = playerWrapper
    self.playerWrapper.delegate = self
    
    self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 500, timescale: 1000), queue: .main) { [weak self] time in
      self?.playerWrapper.reportTimeProgress(UInt(time.value)/1000000)
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    
  }
  
  @objc func getProgramTimestamps() {
    print("getProgramTimestamps")
  }
  
  @objc func playerDidFinishPlay() {
    print("playerDidFinishPlay AVPlayerItemDidPlayToEndTime")
    self.player.replaceCurrentItem(with: nil)
    self.playerWrapper.reportPlaybackEnded()
  }
  
  @objc func playerWantsToSeek(to miliseconds: UInt) {
     print("TivioDebug:seeking wants to seek to", miliseconds)
     self.playerWrapper.seek(to: miliseconds)
  }
  
  func seek(to miliseconds: UInt) {
     print("TivioDebug:seeking received seek from JS", miliseconds)
    self.player.seek(to: CMTimeMake(value: Int64(miliseconds), timescale: 1000))
  }
  
  func setSource(_ source: TivioPlayerSource!) {
    let markers = source.markers
    DispatchQueue.main.async {
        self.playerViewModel?.markers = markers
    }
      
  if source.uri != "" {
      if let adMetadata = source.adMetadata {
          print("AdMetadata is present:", adMetadata)
          // Add any additional handling for adMetadata here
      } else {
          print("No AdMetadata available for this source")
      }
      self.player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: source.uri)!))
      self.player.seek(to: CMTimeMake(value: Int64(source.startPosition), timescale: 1000))
      self.player.play()
  }
  }

  
  func onAdMetadata(_ adMetadata: TivioAdMetadata!) {
    print("AdMetadata:", adMetadata!)
  }
  
  func onMarkers(_ markers: [TivioMarker]!) {
    print("Received following markers: ", markers)
  }

  func onEpgData(_ epg: [TivioEpgItem]!) {
    print("xxxxxxxxxxxx epg", epg)
  }
  
}
