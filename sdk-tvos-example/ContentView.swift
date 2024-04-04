import SwiftUI

struct ContentView: View {
  @EnvironmentObject var playerViewModel: PlayerViewModel

  
  var body: some View {
    GeometryReader { geometry in
      
      LinearGradient(
                      gradient: Gradient(colors: [
                          Color(red: 100 / 255.0, green: 19 / 255.0, blue: 45 / 255.0),
                          Color.black,
                          Color(red: 23 / 255.0, green: 4 / 255.0, blue: 57 / 255.0)
                      ]),
                      startPoint: .topLeading,
                      endPoint: .bottomTrailing
                  )
        .edgesIgnoringSafeArea(.all)
      
      VStack {
        
          Button(action: {
            self.playerViewModel.shouldPlay.toggle()
          }) {
            Image("dvtv-extra-logo")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 70, height: 70)
              .padding()
          }
          .frame(width: 170, height: 100)
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
