import SwiftUI

struct ToggleItem: View {
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text(label)
        }
        .toggleStyle(SwitchToggleStyle())
    }
}
