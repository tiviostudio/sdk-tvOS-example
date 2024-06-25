import SwiftUI
import Tivio

@main
struct example_tvosApp: App {
    var tivio: Tivio
    var playerViewModel = PlayerViewModel()
    var programViewModel = ProgramViewModel()

    init() {
        tivio = Tivio(secret: "QzY8vor8x0G6rooCWqzI", deviceCapabilities: [], verbose: true)

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("TivioInitializationChanged"),
            object: nil,
            queue: .main
        ) { notification in
          if let isInitialized = notification.userInfo?["isInitialized"] as? Bool {
                print("Tivio is initialized: \(isInitialized)")
                // Perform any additional actions when isInitialized changes
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playerViewModel)
                .environmentObject(programViewModel)
        }
    }
}
