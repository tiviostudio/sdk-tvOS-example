//
//  TimeshiftPLayerView.swift
//  sdk-tvos-example
//
//  Created by Richard Biroš on 23.05.2024.
//

import SwiftUI
import AVKit
import Tivio

struct TimeshiftPlayerView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @EnvironmentObject var programViewModel: ProgramViewModel


    private let player = AVPlayer()
    private var playerController: PlayerController {
        return PlayerController(player: self.player, playerViewModel: playerViewModel)
    }

  var body: some View {
              VideoPlayer(player: player)
                  .edgesIgnoringSafeArea(.all)
                  .onAppear {
                      updatePlayerChannel()
                  }
                  .onChange(of: programViewModel.currentProgram.name) { _ in
                      updatePlayerChannel()
                  }
                  .onChange(of: playerViewModel.markers) { _ in
                      updateInterstitialTimeRanges()
                  }
                  .onDisappear {
                      self.playerViewModel.shouldPlay = false
                      self.player.replaceCurrentItem(with: nil)
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

