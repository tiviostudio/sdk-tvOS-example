//
//  ProgramViewModel.swift
//  example-tvos
//
//  Created by Honza Jiráň on 16.05.2024.
//

import Foundation
import Tivio

struct Program {
  let name: String
  let channelName: String
  let programDescription: String
  let imageUrl: String
  let epgFrom: Date
  let epgTo: Date
}

class ProgramViewModel: ObservableObject, TivioProgramGuideDelegate {
  @Published var programs: [Program] = []
  @Published var currentProgram: Program

  init() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    dateFormatter.locale = Locale(identifier: "cs_CZ")

    currentProgram = Program(
      name: "Jak vydělat 2 MILIONY ZA ROK. 🤑💵 Rozkryli jsme to!",
      channelName: "4586",
      programDescription: "Nová generace nových podvodů",
      imageUrl: "https://storage.googleapis.com/tivio-production-input-admin/organizations%2FC34ZsmMHPwvMSdYgFUJe%2Fvideos%2FYkreku0id12aiirgx9NP%2Fcover%2F%401-1711551868165.jpeg",
      epgFrom: dateFormatter.date(from: "2024-05-16T00:03:13+02:00")!,
      epgTo: dateFormatter.date(from: "2024-05-16T00:13:31+02:00")!
    )

    programs = [currentProgram] // Initial mock data
  }

  func updatePrograms(with epgData: [TivioEpgItem]) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    dateFormatter.locale = Locale(identifier: "cs_CZ")

    self.programs = epgData.map { epgItem in
      Program(
        name: epgItem.name,
        channelName: epgItem.channelName,
        programDescription: epgItem.programDescription,
        imageUrl: epgItem.imageUrl,
        epgFrom: dateFormatter.date(from: epgItem.epgFrom)!,
        epgTo: dateFormatter.date(from: epgItem.epgTo)!
      )
    }
  }

  func onEpgData(_ epgData: [TivioEpgItem]!) {
    updatePrograms(with: epgData)
  }
}
