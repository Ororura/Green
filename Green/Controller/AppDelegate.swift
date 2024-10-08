import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var model = KeyboardCleaningModel()

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView(model: model)

        if let window = NSApplication.shared.windows.first {
            window.contentView = NSHostingView(rootView: contentView)
        }
    }
}
