import SwiftUI

struct ContentView: View {
  @EnvironmentObject var playerViewModel: PlayerViewModel

  
  var body: some View {
    GeometryReader { geometry in
      
      LinearGradient(
                      gradient: Gradient(colors: [
                          Color(red: 100 / 255.0, green: 19 / 255.0, blue: 45 / 255.0),
                          Color(red: 26 / 255.0, green: 2 / 255.0, blue: 20 / 255.0),
                          Color(red: 23 / 255.0, green: 4 / 255.0, blue: 57 / 255.0)
                      ]),
                      startPoint: .topLeading,
                      endPoint: .bottomTrailing
                  )
        .edgesIgnoringSafeArea(.all)
      
      HStack(spacing: 20) {
          Button(action: {
            playerViewModel.channel = "dvtv-channel"
            self.playerViewModel.shouldPlay.toggle()
          }) {
            Image("dvtv-extra-logo")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 110, height: 70)
              .padding()
          }
          .padding()
          .frame(width: 230, height: 150)
          .background(Color.black)
          .foregroundColor(Color.black)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .buttonStyle(PlainButtonStyle())
          .fullScreenCover(isPresented: $playerViewModel.shouldPlay) {
              PlayerView()
          }
        
        Button(action: {
          playerViewModel.channel = "starmax-action"
          self.playerViewModel.shouldPlay.toggle()
        }) {
          Image("starmax-action")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 110, height: 70)
            .padding()
        }
        .frame(width: 230, height: 150)
        .background(Color.black)
        .foregroundColor(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $playerViewModel.shouldPlay) {
            PlayerView()
        }
        
//        Button(action: {
//          playerViewModel.channel = "starmax-family"
//          self.playerViewModel.shouldPlay.toggle()
//        }) {
//          Image("starmax-family")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 100, height: 100)
//            .padding()
//        }
//        .frame(width: 260, height: 160)
//        .background(Color.black)
//        .foregroundColor(Color.black)
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .buttonStyle(PlainButtonStyle())
//        .fullScreenCover(isPresented: $playerViewModel.shouldPlay) {
//            PlayerView()
//        }
        
        Button(action: {
          playerViewModel.channel = "starmax-drama"
          self.playerViewModel.shouldPlay.toggle()
        }) {
          Image("starmax-drama")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 110, height: 70)
            .padding()
        }
        .frame(width: 230, height: 150)
        .background(Color.black)
        .foregroundColor(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $playerViewModel.shouldPlay) {
            PlayerView()
        }
        
        Button(action: {
          playerViewModel.channel = "starmax-comedy"
          self.playerViewModel.shouldPlay.toggle()
        }) {
          Image("starmax-comedy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 110, height: 70)
            .padding()
        }
        .frame(width: 230, height: 150)
        .background(Color.black)
        .foregroundColor(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $playerViewModel.shouldPlay) {
            PlayerView()
        }
        
        Button(action: {
          playerViewModel.channel = "oktagon-tv"
          self.playerViewModel.shouldPlay.toggle()
        }) {
          Image("oktagon-logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 110, height: 70)
            .padding()
        }
        .frame(width: 230, height: 150)
        .background(Color.black)
        .foregroundColor(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $playerViewModel.shouldPlay) {
            PlayerView()
        }
        
      }
      .padding()
    }
    .edgesIgnoringSafeArea(.all)
  }
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(PlayerViewModel())
    }
}
