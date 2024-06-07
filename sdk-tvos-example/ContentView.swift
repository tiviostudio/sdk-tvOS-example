import SwiftUI
import Tivio

struct ContentView: View {
  @EnvironmentObject var playerViewModel: PlayerViewModel
  
  @EnvironmentObject var programViewModel: ProgramViewModel
  
//  var epgData: [Any]

  var body: some View {
    GeometryReader { geometry in
      Button(action: {
        // Define channel names for which you want to get the EPG
        let channelNames = ["4586", "starmax-action", "starmax-drama", "starmax-comedy", "oktagon-tv"]
        Tivio.getEpgData(forChannels: channelNames) { epgData in
                print("TivioDebug: Loaded EPG data: ", epgData)
                // Handle the epgData here, e.g., update the view model or state
                if let epgItems = epgData as? [TivioEpgItem] {
                    programViewModel.updatePrograms(with: epgItems)
                }
            }
      }) {
            Text("Get epg data")
      }
        HStack() {
          Spacer()
          VStack(spacing: 8) {
            ChannelButton(imageName: "dvtv-extra-logo", channelName: "4586", playerViewModel: _playerViewModel)
            ScrollView {
              ForEach(programViewModel.programs.filter { $0.channelName == "4586" }, id: \.name) { program in
                ProgramTile(program: program)
              }
            }
          }
          .padding(.horizontal, 10)
          Spacer()
          VStack(spacing: 8) {
            ChannelButton(imageName: "starmax-action", channelName: "starmax-action", playerViewModel: _playerViewModel)
            ScrollView {
              ForEach(programViewModel.programs.filter { $0.channelName == "starmax-action" }, id: \.name) { program in
                ProgramTile(program: program)
              }
            }
          }
          .padding(.horizontal, 10)
          Spacer()
          VStack(spacing: 8) {
            ChannelButton(imageName: "starmax-drama", channelName: "starmax-drama", playerViewModel: _playerViewModel)
            ScrollView {
              ForEach(programViewModel.programs.filter { $0.channelName == "starmax-drama" }, id: \.name) { program in
                ProgramTile(program: program)
              }
            }
          }
          .padding(.horizontal, 10)
          Spacer()
          VStack(spacing: 8) {
            ChannelButton(imageName: "starmax-comedy", channelName: "starmax-comedy", playerViewModel: _playerViewModel)
            ScrollView {
              ForEach(programViewModel.programs.filter { $0.channelName == "starmax-comedy" }, id: \.name) { program in
                ProgramTile(program: program)
              }
            }
          }
          .padding(.horizontal, 10)
          Spacer()
          VStack(spacing: 8) {
            ChannelButton(imageName: "oktagon-logo", channelName: "oktagon-tv", playerViewModel: _playerViewModel)
            ScrollView {
              ForEach(programViewModel.programs.filter { $0.channelName == "oktagon-tv" }, id: \.name) { program in
                ProgramTile(program: program)
              }
            }
          }
          .padding(.horizontal, 10)
          //Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
      
    }
    .edgesIgnoringSafeArea(.all)
    .background(Color.black.edgesIgnoringSafeArea(.all))
  }

  struct ChannelButton: View {
    var imageName: String
    var channelName: String
    @EnvironmentObject var playerViewModel: PlayerViewModel

    var body: some View {
      Button(action: {
        playerViewModel.channel = channelName
        playerViewModel.shouldPlayLive.toggle()
      }) {
        Image(imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 130, height: 70)
          .padding()
      }
      .foregroundColor(Color.black)
      .background(Color.black)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .buttonStyle(PlainButtonStyle())
      .fullScreenCover(isPresented: $playerViewModel.shouldPlayLive) {
        PlayerView()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(PlayerViewModel())
      .environmentObject(ProgramViewModel())
  }
}
