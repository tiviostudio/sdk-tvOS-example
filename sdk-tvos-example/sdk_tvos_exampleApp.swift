//
//  sdk_tvos_exampleApp.swift
//  sdk-tvos-example
//
//  Created by Ladislav Navratil on 02.03.2022.
//

import SwiftUI
import Tivio

@main
struct example_tvosApp: App {
  
  var tivio: Tivio
  var playerViewModel = PlayerViewModel()
  var programViewModel = ProgramViewModel()
  
  init() {
    tivio = Tivio(secret: "QzY8vor8x0G6rooCWqzI", deviceCapabilities: [], verbose: true)
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(playerViewModel)
        .environmentObject(programViewModel)
    }
  }
}
