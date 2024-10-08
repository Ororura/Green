import SwiftUI

@main
struct GreenApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            // Пустое содержимое, оно будет заменено в AppDelegate
            EmptyView()
        }
    }
}
