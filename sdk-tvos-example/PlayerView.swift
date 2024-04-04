//
//  PlayerView.swift
//  example-ios
//
//  Created by Ladislav Navratil on 17.01.2022.
//

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
      .onAppear() {
        if((player.currentItem == nil)) {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
          
            self.playerController.playerWrapper.setSource(TivioPlayerSource(
              channel: "dvtv-channel",
                 mode: "live",
                  uri: "",
              epgFrom: UInt(Date().timeIntervalSince1970) * 1000,
                epgTo: UInt(Date().timeIntervalSince1970) * 1000,
          streamStart: UInt(Date().timeIntervalSince1970) * 1000,
    startFromPosition: 0
                    ), calibrationId: "default")
      }
    }
      .onDisappear() {
        self.playerViewModel.shouldPlay = false
        player.replaceCurrentItem(with: nil)
      }
  }
}
