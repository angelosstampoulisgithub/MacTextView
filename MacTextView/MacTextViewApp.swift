//
//  MacTextViewApp.swift
//  MacTextView
//
//  Created by Angelos Staboulis on 18/3/26.
//

import SwiftUI
import AppKit




@main
struct MacTextViewApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
                   CommandGroup(replacing: .newItem) { }
                   CommandGroup(replacing: .saveItem) { }
                   CommandGroup(replacing: .windowList) { }
               }
    }
}
