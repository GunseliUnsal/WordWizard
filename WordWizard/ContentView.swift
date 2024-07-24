//
//  ContentView.swift
//  WordWizard
//
//  Created by Günseli Ünsal on 24.07.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var unusedLetters = (0..<9).map {_ in Letter()}
    @State private var usedLetters = [Letter]()
    @State private var dictionary = Set<String>()
    
    @Namespace private var animation
    
    var body: some View {
        VStack {
            HStack{
                ForEach(usedLetters) {letter in
                    LetterView(letter: letter, color: wordIsValid() ? .green : .red, onTap: remove)
                        .matchedGeometryEffect(id: letter, in: animation)
                }
                
            }
            
            HStack{
                ForEach(unusedLetters) {letter in
                    LetterView(letter: letter, color: .yellow, onTap: add)
                        .matchedGeometryEffect(id: letter, in: animation)
                }
            }
        }
        .padding()
        .onAppear(perform: {
            load()
        })
    }
    
    func load() {
        guard let url = Bundle.main.url(forResource: "dictionary", withExtension: "txt") else { return }
        guard let contents = try? String(contentsOf: url) else { return }
        dictionary = Set(contents.components(separatedBy: .newlines))
    }
    
    func add(_ letter: Letter) {
        guard let index = unusedLetters.firstIndex(of: letter) else { return }
        
        withAnimation(.spring){
            unusedLetters.remove(at: index)
            usedLetters.append(letter)
        }
    }

    func remove(_ letter: Letter) {
        guard let index = usedLetters.firstIndex(of: letter) else { return }
        
        withAnimation(.spring){
            usedLetters.remove(at: index)
            unusedLetters.append(letter)
        }
    }
    
    func wordIsValid() -> Bool {
        let word = usedLetters.map(\.character).joined().lowercased()
        return dictionary.contains(word)
    }
}

#Preview {
    ContentView()
}
