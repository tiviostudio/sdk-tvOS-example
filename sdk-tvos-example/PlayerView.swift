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
  private let player = AVPlayer()
  private var playerController: PlayerController {
    return PlayerController(player: self.player)
  }
  
  var body: some View {
    VideoPlayer(player: player)
      .onPlayPauseCommand {
        if((player.currentItem == nil)) {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
          
            self.playerController.playerWrapper.setSource(TivioPlayerSource(
              channel: "prima hd",
                 mode: "timeshift",
                  uri: "https://cs0a-ttc.as.4net.tv/at/hls/master/vod_703_h264hd12.m3u8?start=1645279680&end=1645287300&device=88a292a41acd5b6035aa1ebfb067057c&stream_profiles=h264hd12&backoffice=testing",
              epgFrom: UInt(dateFormater.date(from: "2022-02-19 15:10:00")!.timeIntervalSince1970)*1000,
                epgTo: UInt(dateFormater.date(from: "2022-02-19 16:55:00")!.timeIntervalSince1970)*1000,
          streamStart: UInt(dateFormater.date(from: "2022-02-19 15:09:00")!.timeIntervalSince1970)*1000,
    startFromPosition: 60000
                    ), calibrationId: "default")
                  }
      }
  }
}
