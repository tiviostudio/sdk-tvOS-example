//
//  PlayerViewModel.swift
//  example-tvos
//
//  Created by Honza Jiráň on 04.04.2024.
//

import Foundation
import Combine
import Tivio

class PlayerViewModel: ObservableObject {
    @Published var shouldPlayLive: Bool = false
    @Published var shouldPlay: Bool = false
    @Published var channel: String = "4586"
    @Published var markers: [TivioMarker] = []
}
