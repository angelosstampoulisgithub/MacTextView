//
//  ContentView.swift
//  MacTextView
//
//  Created by Angelos Staboulis on 18/3/26.
//

import SwiftUI
class DocumentState: ObservableObject {
    @Published var text: String = ""
    @Published var fileURL: URL? = nil
}
struct ContentView: View {
    
    @StateObject private var doc = DocumentState()
    var body: some View {
        MacTextView(text: $doc.text)
                   .onReceive(NotificationCenter.default.publisher(for: .newFile)) { _ in
                       doc.text = ""
                       doc.fileURL = nil
                   }
                   .onReceive(NotificationCenter.default.publisher(for: .openFile)) { note in
                       if let content = note.object as? (String, URL) {
                           doc.text = content.0
                           doc.fileURL = content.1
                       }
                   }
                   .onReceive(NotificationCenter.default.publisher(for: .saveFile)) { _ in
                       saveCurrentText()
                   }
                   .onReceive(NotificationCenter.default.publisher(for: .saveFileAs)) { _ in
                       saveAs()
                   }
           }

           private func saveCurrentText() {
               NotificationCenter.default.post(name: .performSave, object: (doc.text, doc.fileURL))
           }

           private func saveAs() {
               NotificationCenter.default.post(name: .performSaveAs, object: doc.text)
           }
}

#Preview {
    ContentView()
}
extension Notification.Name {
    static let newFile = Notification.Name("newFile")
    static let openFile = Notification.Name("openFile")
    static let saveFile = Notification.Name("saveFile")
    static let saveFileAs = Notification.Name("saveFileAs")
    static let performSave = Notification.Name("performSave")
    static let performSaveAs = Notification.Name("performSaveAs")
}
