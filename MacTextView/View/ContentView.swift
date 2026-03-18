//
//  ContentView.swift
//  MacTextView
//
//  Created by Angelos Staboulis on 18/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var text = "Write something…"
    var body: some View {
       
            MacTextView(text: $text)
                       .frame(minWidth: 400, minHeight: 300)
       
    }
}

#Preview {
    ContentView()
}
