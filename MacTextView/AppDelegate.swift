//
//  AppDelegate.swift
//  MacTextView
//
//  Created by Angelos Staboulis on 21/3/26.
//

import Foundation
import SwiftUI
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        clearDefaultMenus()
        setupMenus()
        NotificationCenter.default.addObserver(
            forName: .performSave,
            object: nil,
            queue: .main
        ) { note in
            if let (text, url) = note.object as? (String, URL?) {
                self.saveToDisk(text: text, url: url)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: .performSaveAs,
            object: nil,
            queue: .main
        ) { note in
            if let text = note.object as? String {
                self.saveAsToDisk(text: text)
            }
        }
        
    }
    func saveToDisk(text: String, url: URL?) {
        guard let url = url else {
            saveAsToDisk(text: text)
            return
        }
        
        do {
            try text.data(using: .utf8)?.write(to: url)
        } catch {
            print("Save failed:", error)
        }
    }
    func saveAsToDisk(text: String) {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.plainText]
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = "Untitled.txt"
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                do {
                    try text.data(using: .utf8)?.write(to: url)
                    
                    // ενημέρωσε το ContentView ότι σώθηκε σε νέο URL
                    NotificationCenter.default.post(
                        name: .openFile,
                        object: (text, url)
                    )
                    
                } catch {
                    print("Save As failed:", error)
                }
            }
        }
    }
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        true
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
    
    @objc func showReplacePanel(_ sender: Any?) {
        let action = NSTextFinder.Action.showReplaceInterface
        NSApp.sendAction(
            #selector(NSResponder.performTextFinderAction(_:)),
            to: nil,
            from: NSNumber(value: action.rawValue)
        )
    }
    
    
    @objc func replaceAndFind() {
        let action = NSTextFinder.Action.showReplaceInterface
        NSApp.sendAction(
            #selector(NSResponder.performTextFinderAction(_:)),
            to: nil,
            from: NSNumber(value: action.rawValue)
        )
    }
    private func clearDefaultMenus() {
        NSApplication.shared.mainMenu = NSMenu()   // άδειο menu bar
    }
    @objc func performSave(_ sender: Any?) {
        NotificationCenter.default.post(name: .saveFile, object: nil)
    }
    
    @objc func performSaveAs(_ sender: Any?) {
        NotificationCenter.default.post(name: .saveFileAs, object: nil)
    }
    @objc func openDocument(_ sender: Any?) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.plainText]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            
            do {
                let data = try Data(contentsOf: url)
                let text = String(decoding: data, as: UTF8.self)
                
                // Ενημέρωσε το ContentView
                NotificationCenter.default.post(
                    name: .openFile,
                    object: (text, url)
                )
            } catch {
                print("Open failed:", error)
            }
        }
    }
    @objc func printDocument(_ sender: Any?) {
        guard let window = NSApp.keyWindow,
              let contentView = window.contentView else { return }
        
        let printInfo = NSPrintInfo.shared
        let operation = NSPrintOperation(view: contentView, printInfo: printInfo)
        operation.run()
    }
    @objc func newFile(_ sender: Any?) {
        NotificationCenter.default.post(name: .newFile, object: nil)
    }
    
    @objc func customCut(_ sender: Any?) {
        NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: sender)
    }
    
    @objc func customCopy(_ sender: Any?) {
        NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: sender)
    }
    
    @objc func customPaste(_ sender: Any?) {
        NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: sender)
    }
    
    @objc func customSelectAll(_ sender: Any?) {
        NSApp.sendAction(#selector(NSText.selectAll(_:)), to: nil, from: sender)
    }
    
    private func setupMenus() {
        let mainMenu = NSMenu()
        
        // MARK: - App Menu
        let appItem = NSMenuItem()
        let appMenu = NSMenu(title: "MacTextView")
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
                         action: #selector(newFile(_:)),
                         keyEquivalent: "n")
        
        fileMenu.addItem(withTitle: "Open…",
                         action: #selector(NSDocumentController.openDocument(_:)),
                         keyEquivalent: "o")
        
        fileMenu.addItem(NSMenuItem.separator())
        
        fileMenu.addItem(withTitle: "Save",
                         action: #selector(performSave(_:)),
                         keyEquivalent: "s")
        
        fileMenu.addItem(withTitle: "Save As…",
                         action: #selector(performSaveAs(_:)),
                         keyEquivalent: "S")
        
        fileMenu.addItem(NSMenuItem.separator())
        
        fileMenu.addItem(withTitle: "Print…",
                         action: #selector(printDocument(_:)),
                         keyEquivalent: "p")
        
        fileItem.submenu = fileMenu
        mainMenu.addItem(fileItem)
        
        // MARK: - Edit Menu
        let editItem = NSMenuItem()
        let editMenu = NSMenu(title: "Edit")
        
        // Basic editing
        editMenu.addItem(withTitle: "Cut", action: #selector(customCut(_:)), keyEquivalent: "x")
        editMenu.addItem(withTitle: "Copy", action: #selector(customCopy(_:)), keyEquivalent: "c")
        editMenu.addItem(withTitle: "Paste", action: #selector(customPaste(_:)), keyEquivalent: "v")
        editMenu.addItem(withTitle: "Select All", action: #selector(customSelectAll(_:)), keyEquivalent: "a")
        editMenu.addItem(NSMenuItem.separator())
        
        // Find…
        let findItem = NSMenuItem(
            title: "Find…",
            action: #selector(NSResponder.performTextFinderAction(_:)),
            keyEquivalent: "f"
        )
        findItem.tag = Int(NSTextFinder.Action.showFindInterface.rawValue)
        editMenu.addItem(findItem)

        // Find Next
        let findNextItem = NSMenuItem(
            title: "Find Next",
            action: #selector(NSResponder.performTextFinderAction(_:)),
            keyEquivalent: "g"
        )
        findNextItem.tag = Int(NSTextFinder.Action.nextMatch.rawValue)
        editMenu.addItem(findNextItem)

        // Find Previous
        let findPrevItem = NSMenuItem(
            title: "Find Previous",
            action: #selector(NSResponder.performTextFinderAction(_:)),
            keyEquivalent: "G"
        )
        findPrevItem.tag = Int(NSTextFinder.Action.previousMatch.rawValue)
        editMenu.addItem(findPrevItem)

        editMenu.addItem(NSMenuItem.separator())

        // Replace…
        let replaceItem = NSMenuItem(
            title: "Replace…",
            action: #selector(NSResponder.performTextFinderAction(_:)),
            keyEquivalent: ""
        )
        replaceItem.tag = Int(NSTextFinder.Action.showReplaceInterface.rawValue)
        editMenu.addItem(replaceItem)

        // Replace and Find
        let replaceFindItem = NSMenuItem(
            title: "Replace and Find",
            action: #selector(NSResponder.performTextFinderAction(_:)),
            keyEquivalent: ""
        )
        replaceFindItem.tag = Int(NSTextFinder.Action.replaceAndFind.rawValue)
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
