//
//  ContentView.swift
//  example-tvos
//
//  Created by Ladislav Navratil on 21.02.2022.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    PlayerView()
      .transition(.move(edge: .bottom))
      .edgesIgnoringSafeArea(.all)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

