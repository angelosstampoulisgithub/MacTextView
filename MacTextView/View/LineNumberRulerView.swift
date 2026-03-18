//
//  LineNumberRulerView.swift
//  MacTextView
//
//  Created by Angelos Staboulis on 18/3/26.
//

import Foundation
import AppKit
final class LineNumberRulerView: NSRulerView {
    weak var textView: NSTextView?

    init(textView: NSTextView) {
        self.textView = textView
        super.init(scrollView: textView.enclosingScrollView!, orientation: .verticalRuler)
        self.clientView = textView
        self.ruleThickness = 40
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawHashMarksAndLabels(in rect: NSRect) {
        guard let textView = textView,
              let layoutManager = textView.layoutManager,
              let textContainer = textView.textContainer else { return }

        let text = textView.string as NSString
        let totalLines = textView.string.components(separatedBy: "\n").count

        let font = NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .regular)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.secondaryLabelColor
        ]

        for line in 0..<totalLines {
            let charRange = text.lineRange(
                for: NSRange(location: text.location(ofLine: line), length: 0)
            )

            let glyphRange = layoutManager.glyphRange(
                forCharacterRange: charRange,
                actualCharacterRange: nil
            )

            let rect = layoutManager.boundingRect(
                forGlyphRange: glyphRange,
                in: textContainer
            )

            let y = rect.minY
                + textView.textContainerInset.height
                - textView.visibleRect.minY

            let number = "\(line + 1)" as NSString
            number.draw(at: NSPoint(x: 5, y: y), withAttributes: attrs)
        }
    }
}

extension NSString {
    func location(ofLine line: Int) -> Int {
        var count = 0
        var index = 0

        while index < length {
            if count == line { return index }
            if character(at: index) == 10 { count += 1 } // newline
            index += 1
        }

        return length
    }
}
