//
//  MacTextView.swift
//  MacTextView
//
//  Created by Angelos Staboulis on 18/3/26.
//

import Foundation
import SwiftUI
import AppKit

struct MacTextView: NSViewRepresentable {
    @Binding var text: String
    var isEditable: Bool = true
    var font: NSFont = .systemFont(ofSize: 14)

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true

        let textView = CustomNSTextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isRichText = false
        textView.usesFindPanel = true
        textView.font = .systemFont(ofSize: 14)
        textView.string = text
        textView.delegate = context.coordinator
        textView.isContinuousSpellCheckingEnabled = true
        textView.backgroundColor = .textBackgroundColor
        textView.textColor = .textColor
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]

        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(width: scrollView.contentSize.width,
                                                       height: .greatestFiniteMagnitude)
        textView.textContainer?.heightTracksTextView = false
        scrollView.documentView = textView
        scrollView.hasVerticalRuler = true
        scrollView.rulersVisible = true
        scrollView.verticalRulerView = LineNumberRulerView(textView:textView)
        scrollView.hasHorizontalRuler = false
        scrollView.contentView.postsBoundsChangedNotifications = true

        NotificationCenter.default.addObserver(
            forName: NSView.boundsDidChangeNotification,
            object: scrollView.contentView,
            queue: .main
        ) { _ in
            scrollView.verticalRulerView?.needsDisplay = true
        }
      

        return scrollView
    }
 

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        if textView.string != text {
            textView.string = text
        }
        textView.isEditable = isEditable
        textView.font = font
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MacTextView

        init(_ parent: MacTextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }

            // Update SwiftUI binding
            parent.text = textView.string

            textView.enclosingScrollView?.verticalRulerView?.needsDisplay = true
        }
        
    }
}
