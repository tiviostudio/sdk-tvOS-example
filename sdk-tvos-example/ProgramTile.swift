//
//  ProgramTile.swift
//  sdk-tvos-example
//
//  Created by Richard Biroš on 23.05.2024.
//

import Foundation
import SwiftUI

struct ProgramTile: View {
    var program: Program
//  @FocusState private var isFocused: Bool
  @EnvironmentObject var playerViewModel: PlayerViewModel
  @EnvironmentObject var programViewModel: ProgramViewModel
  @State private var isPresentingFullScreenCover = false

    var body: some View {
      Button(action: {
        print("Program selected: \(program.name)")
        programViewModel.currentProgram = program
//        playerViewModel.channel = channelName
        playerViewModel.shouldPlay.toggle()
        isPresentingFullScreenCover = true
      }) {
        VStack(alignment: .leading, spacing: 10) {
          AsyncImage(url: URL(string: program.imageUrl))
//                .resizable()
//                .aspectRatio(contentMode: .fill)
                .frame(width: 270, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 0.5))
          
          Text("\(program.epgFrom.formatted(date: .omitted, time: .shortened)) - \(program.epgTo.formatted(date: .omitted, time: .shortened))")
            .font(.system(size: 14))
            .foregroundColor(.gray)
            
          Text(program.name)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .lineLimit(1)
            
          Text(program.programDescription)
            .font(.system(size: 16))
            .foregroundColor(.gray)
            .lineLimit(2)
        }
        .padding(10)
        .background(Color(red: 12 / 255, green: 13 / 255, blue: 16 / 255, opacity: 1))
        .frame(width: 270)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .buttonStyle(PlainButtonStyle())
//              .focusable(true) { focused in
//                  isFocused = focused
//              }
      .background(Color.clear)
      .frame(width: 270)
      .fullScreenCover(isPresented: $isPresentingFullScreenCover) {
        TimeshiftPlayerView()
      }
    }
}

