import Cocoa
import IOKit.hid

class KeyboardEventInterceptor {
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var hidManager: IOHIDManager?

    func start() {
        // Start CGEvent tap for standard key up/down events
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(1 << CGEventType.keyUp.rawValue | 1 << CGEventType.keyDown.rawValue),
            callback: eventCallBack,
            userInfo: nil
        )
        
        if let eventTap = eventTap {
            runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
        
        // Start IOHIDManager to intercept special keys
        startIOHIDManager()
    }

    func stop() {
        // Stop CGEvent tap
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            runLoopSource = nil
            self.eventTap = nil
        }

        // Stop IOHIDManager
        if let hidManager = hidManager {
            IOHIDManagerClose(hidManager, IOOptionBits(kIOHIDOptionsTypeNone))
            self.hidManager = nil
        }
    }
    
    let eventCallBack: CGEventTapCallBack = {(tapProxy, type, event, userInfo) in
        print("CGEvent detected: \(type.rawValue)")
        return nil
    }
    
    func startIOHIDManager() {
        hidManager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
        
        guard let hidManager = hidManager else {
            print("Failed to create HID Manager")
            return
        }
        
        IOHIDManagerSetDeviceMatching(hidManager, nil)
        IOHIDManagerRegisterInputValueCallback(hidManager, { context, result, sender, value in
            let element = IOHIDValueGetElement(value)
            let scancode = IOHIDElementGetUsage(element)
            
            print("IOHID Event: Scancode = \(scancode)")
            
            // Handle special keys like Fn, brightness, volume, etc.
            if scancode == 0x3F { // Example: Fn key
                print("Fn key pressed!")
            }
            
        }, nil)
        
        IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        IOHIDManagerOpen(hidManager, IOOptionBits(kIOHIDOptionsTypeNone))
    }
}
