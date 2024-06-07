//
//  EpgDataModel.swift
//  example-tvos
//
//  Created by Honza Jiráň on 15.05.2024.
//

import Foundation
import Combine

class EpgDataModel: ObservableObject {
    @Published var epgData: [EpgItem] = []
}

struct EpgItem: Decodable {
    let name: String
    let channelName: String
    let programDescription: String
    let imageUrl: String
    let epgFrom: String
    let eppgTo: String
}

//extension EpgDataModel {
//    @objc func updateData(with data: [EpgItem]) {
//        DispatchQueue.main.async {
//            self.epgData = data
//        }
//    }
//}
