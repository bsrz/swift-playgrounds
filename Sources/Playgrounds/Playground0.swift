import SwiftUI

class AppModel: ObservableObject {

  enum Destination {
    case settings(SettingsModel)
  }

  @Published var destination: Destination?

  init(destination: Destination? = nil) {
    self.destination = destination
  }
}

class SettingsModel: ObservableObject {

  enum Destination {
    case general(GeneralModel)
  }

  @Published var destination: Destination?

  init(destination: Destination? = nil) {
    self.destination = destination
  }
}

class GeneralModel: ObservableObject {
}

struct AppView: View {

  @ObservedObject var model: AppModel

  var body: some View {
    NavigationStack {
      Text("App View")
    }
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(
      model: AppModel(
        destination: .settings(
          SettingsModel(
            destination: .general(GeneralModel())
          )
        )
      )
    )
  }
}

