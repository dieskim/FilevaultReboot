//
//  FilevaultRebootApp.swift
//  FilevaultReboot
//
//  Created by Dieskim on 6/8/23.
//
import SwiftUI
import ServiceManagement

@main
struct FilevaultRebootApp: App {

    @State private var username = NSUserName()
    @State private var password = ""
    
    init() {
        do {
            try SMAppService.mainApp.register()
        } catch {
            print("Error registering for startup: \(error)")
        }
    }
    
    var body: some Scene {
       
        MenuBarExtra("FileVaultReboot", systemImage: "power.circle"){
            ContentView()
        
        }.menuBarExtraStyle(.window)
    
    }
}
