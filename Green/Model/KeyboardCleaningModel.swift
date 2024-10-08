import Foundation
import Combine

class KeyboardCleaningModel: ObservableObject {
    private var interceptor = KeyboardEventInterceptor()
    
    @Published var isKeyboardCleaningOn: Bool = false {
        didSet {
            if isKeyboardCleaningOn {
                interceptor.start()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) { [weak self] in
                        self?.interceptor.stop()
                    }
            } else {
                interceptor.stop()
            }
        }
    }
}
