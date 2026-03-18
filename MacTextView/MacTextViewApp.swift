//
//  MacTextViewApp.swift
//  MacTextView
//
//  Created by Angelos Staboulis on 18/3/26.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        clearDefaultMenus()
        setupMenus()
    }
    @objc func showFindPanel() {
        NSApp.keyWindow?.makeFirstResponder(NSApp.keyWindow?.firstResponder)
        NSApp.sendAction(#selector(NSResponder.performTextFinderAction(_:)),
                         to: nil,
                         from: NSTextFinder.Action.showFindInterface)
    }

    @objc func findNext() {
        NSApp.sendAction(#selector(NSResponder.performTextFinderAction(_:)),
                         to: nil,
                         from: NSTextFinder.Action.nextMatch)
    }

    @objc func findPrevious() {
        NSApp.sendAction(#selector(NSResponder.performTextFinderAction(_:)),
                         to: nil,
                         from: NSTextFinder.Action.previousMatch)
    }

    @objc func showReplacePanel() {
        NSApp.sendAction(#selector(NSResponder.performTextFinderAction(_:)),
                         to: nil,
                         from: NSTextFinder.Action.showReplaceInterface)
    }

    @objc func replaceAndFind() {
        NSApp.sendAction(#selector(NSResponder.performTextFinderAction(_:)),
                         to: nil,
                         from: NSTextFinder.Action.replaceAndFind)
    }
    private func clearDefaultMenus() {
        NSApplication.shared.mainMenu = NSMenu()   // άδειο menu bar
    }

    private func setupMenus() {
        let mainMenu = NSMenu()

        // MARK: - App Menu
        let appItem = NSMenuItem()
        let appMenu = NSMenu(title: "Application")
        appMenu.addItem(withTitle: "About",
                        action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
                        keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Quit",
                        action: #selector(NSApplication.terminate(_:)),
                        keyEquivalent: "q")
        appItem.submenu = appMenu
        mainMenu.addItem(appItem)

        // MARK: - File Menu
        let fileItem = NSMenuItem()
        let fileMenu = NSMenu(title: "File")
        fileMenu.addItem(withTitle: "New",
                         action: #selector(NSDocumentController.newDocument(_:)),
                         keyEquivalent: "n")
        fileMenu.addItem(withTitle: "Open…",
                         action: #selector(NSDocumentController.openDocument(_:)),
                         keyEquivalent: "o")
        fileMenu.addItem(NSMenuItem.separator())
        fileMenu.addItem(withTitle: "Save",
                         action: #selector(NSDocument.save(_:)),
                         keyEquivalent: "s")
        fileMenu.addItem(withTitle: "Save As…",
                         action: #selector(NSDocument.saveAs(_:)),
                         keyEquivalent: "S")
        fileMenu.addItem(NSMenuItem.separator())
        fileMenu.addItem(withTitle: "Print…",
                         action: #selector(NSView.printView(_:)),
                         keyEquivalent: "p")
        fileItem.submenu = fileMenu
        mainMenu.addItem(fileItem)

        // MARK: - Edit Menu
        let editItem = NSMenuItem()
        let editMenu = NSMenu(title: "Edit")

        // Basic editing
        editMenu.addItem(withTitle: "Cut",   action: #selector(NSText.cut(_:)),   keyEquivalent: "x")
        editMenu.addItem(withTitle: "Copy",  action: #selector(NSText.copy(_:)),  keyEquivalent: "c")
        editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(withTitle: "Select All",
                         action: #selector(NSText.selectAll(_:)),
                         keyEquivalent: "a")
        editMenu.addItem(NSMenuItem.separator())
        
        // MARK: - Find
        let findItem = NSMenuItem(
            title: "Find…",
            action: #selector(NSResponder.performTextFinderAction(_:)),
            keyEquivalent: "f"
        )
        findItem.tag = 1
        editMenu.addItem(findItem)

        let findNextItem = NSMenuItem(
            title: "Find Next",
            action: #selector(NSResponder.performTextFinderAction(_:)),
            keyEquivalent: "g"
        )
        findNextItem.tag = 2
        editMenu.addItem(findNextItem)

        let findPrevItem = NSMenuItem(
            title: "Find Previous",
            action: #selector(NSResponder.performTextFinderAction(_:)),
            keyEquivalent: ""
        )
        findPrevItem.tag = 3
        editMenu.addItem(findPrevItem)

        editMenu.addItem(NSMenuItem.separator())

        // MARK: - Replace
        let replaceItem = NSMenuItem(
            title: "Replace…",
            action: #selector(NSResponder.performTextFinderAction(_:)),
            keyEquivalent: ""
        )
        replaceItem.tag = 4
        editMenu.addItem(replaceItem)

        let replaceFindItem = NSMenuItem(
            title: "Replace and Find",
            action: #selector(NSResponder.performTextFinderAction(_:)),
            keyEquivalent: ""
        )
        replaceFindItem.tag = 5
        editMenu.addItem(replaceFindItem)


        editMenu.addItem(NSMenuItem.separator())
      

        editItem.submenu = editMenu
        mainMenu.addItem(editItem)

        // MARK: - Help Menu
        let helpItem = NSMenuItem()
        let helpMenu = NSMenu(title: "Help")
        helpMenu.addItem(withTitle: "About",
                         action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
                         keyEquivalent: "")
        helpItem.submenu = helpMenu
        mainMenu.addItem(helpItem)

        NSApplication.shared.mainMenu = mainMenu
    }
}


@main
struct MacTextViewApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
    }
}
