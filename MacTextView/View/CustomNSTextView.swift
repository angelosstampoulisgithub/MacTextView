//
//  CustomNSTextView.swift
//  MacTextView
//
//  Created by Angelos Staboulis on 18/3/26.
//

import Foundation
import AppKit
final class CustomNSTextView: NSTextView {
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
    }
    override func viewDidMoveToWindow() {
           super.viewDidMoveToWindow()
           self.window?.makeFirstResponder(self)
    }
}
