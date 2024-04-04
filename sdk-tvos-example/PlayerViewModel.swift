//
//  PlayerViewModel.swift
//  sdk-tvos-example
//
//  Created by Honza Jiráň on 04.04.2024.
//

import Foundation
import Combine

class PlayerViewModel: ObservableObject {
    @Published var shouldPlay: Bool = false
}
