//
//  PlayerViewModel.swift
//  example-tvos
//
//  Created by Honza Jiráň on 04.04.2024.
//

import Foundation
import Combine

class PlayerViewModel: ObservableObject {
    @Published var shouldPlay: Bool = false
    @Published var channel: String = "dvtv-channel"
}
