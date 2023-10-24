import Cocoa
import SwiftUI
import LaunchAtLogin

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    @IBOutlet weak var statusMenu: NSMenu!
    
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.menu = statusMenu
        statusItem?.button?.image = NSImage(systemSymbolName: "power.circle", accessibilityDescription: nil)
        statusItem?.button?.action = #selector(togglePopover(_:)) // Add this line
        statusItem?.target = self // Add this line

        let contentView = ContentView()
        
        popover.contentViewController = NSHostingController(rootView: contentView)
        popover.behavior = .transient
        
        // enable LaunchAtLogin
        LaunchAtLogin.isEnabled = true
        
    }
    
    
    @objc func togglePopover(_ sender: AnyObject) {
        if let button = statusItem?.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
