import SwiftUI

struct ContentView: View {
    @ObservedObject var model: KeyboardCleaningModel
    
    var body: some View {
        VStack {
            List {
                ToggleItem(label: "Keyboard cleaning", isOn: $model.isKeyboardCleaningOn)
                ToggleItem(label: "More space", isOn: .constant(false)) // Заглушка
            }
            .padding()
        }
    }
}
