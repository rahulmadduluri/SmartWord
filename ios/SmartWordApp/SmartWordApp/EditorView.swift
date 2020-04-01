//
//  Editor.swift
//  SmartWordApp
//
//  Created by Rahul Madduluri on 3/22/20.
//  Copyright © 2020 rm. All rights reserved.
//

import SwiftUI

struct TextView: NSViewRepresentable {
    
    @Binding var text: String
    
    func makeNSView(context: Context) -> NSTextView {
        let tv = NSTextView(frame: .zero)
        tv.backgroundColor = NSColor.black
        return tv
    }

    func updateNSView(_ textView: NSTextView, context: Context) {
        textView.string = text
    }
}

struct EditorView: View {
    
    @State private var typingText: String = "Start Typing :)"
    @State private var isEditing = false
    
    @State private var suggestions: [String] = []
    
    @State private var keystrokes = 0
    
    var model: GPT2
    
    init () {
        model = GPT2(strategy: .topK(40))
    }
    
    var body: some View {
        let binding = Binding<String>(get: {
            self.typingText
        }, set: {
            self.typingText = $0
            if self.keystrokes == 5 {
                self.suggestions = []
                self.fetchSuggestions()
                self.keystrokes = 0
            } else {
                self.keystrokes += 1
            }
        })

        return (
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 0) {
                    Text("Magic Typewriter")
                        .font(Font.system(size: 28))
                        .bold()
                        .foregroundColor(Color.white)
                    VStack {
                        TextView(text: binding)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 400, alignment: .center)
//                        TextView(text: binding, isEditing: $isEditing, textColor: .white, backgroundColor: .black)
//                            .font(Font.system(size: 20))
//                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 250, alignment: .center)
                        // for each suggestion
                        List(self.suggestions.reversed(), id: \.self) { suggestion in
                            SuggestionRow(suggestion: suggestion)
                        }.cornerRadius(10)
                    }.padding().padding()
                }
            }
        )
    }
    
    func fetchSuggestions() {
        DispatchQueue.global(qos: .userInitiated).async {
            _ = self.model.generate(text: self.typingText, nTokens: 10) { completion, time in
                DispatchQueue.main.async {
//                    let startingTxt = NSMutableAttributedString(string: typingText, attributes: [
//                        NSAttributedString.Key.font: Font.system(size: 28) as Any,
//                    ])
//                    let completeTxt = NSAttributedString(string: completion, attributes: [
//                        NSAttributedString.Key.font: Font.system(size: 28) as Any,
//                        NSAttributedString.Key.backgroundColor: #colorLiteral(red: 0.8257101774, green: 0.8819463849, blue: 0.9195404649, alpha: 1),
//                    ])
//                    startingTxt.append(completeTxt)
//                    self.textView.attributedText = startingTxt
//                    self.speedLabel.text = String(format: "%.2f", 1 / time)
                    self.suggestions.append(completion)
                }
            }
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
