import SwiftUI
import SwiftUINavigation

struct MyButtonStyle: PrimitiveButtonStyle {
    private struct Inner: ButtonStyle {
        @Binding var isPressed: Bool

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .opacity(configuration.isPressed ? 0.25 : 1)
                .contentShape(Rectangle())
                .onAppear { isPressed = configuration.isPressed }
                .onChange(of: configuration.isPressed) { isPressed = $0 }
        }
    }

    @State private var isPressed = false

    func makeBody(configuration: Configuration) -> some View {
        Button(
            action: { configuration.trigger() },
            label: { configuration.label }
        )
        .buttonStyle(Inner(isPressed: $isPressed))
        .listRowBackground(
            isPressed
                ? Color.gray.opacity(0.25)
                : Color.white
        )
    }
}

struct ContentView: View {

    enum Destination: String, CaseIterable {
        case one
        case two
    }

    @State var destination: Destination?

    var body: some View {
        NavigationStack {
            List {
                Button {
                    destination = .one
                } label: {
                    Text("Go to one")
                }
                .navigationDestination(
                    unwrapping: $destination,
                    case: /Destination.one
                ) { _ in
                    Text("yes, this is one")
                }

                Button {
                    destination = .two
                } label: {
                    Text("Go to two")
                }
                .navigationDestination(
                    unwrapping: $destination,
                    case: /Destination.two
                ) { _ in
                    Text("wait, this is 2!")
                }
            }
        }
        .buttonStyle(MyButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

