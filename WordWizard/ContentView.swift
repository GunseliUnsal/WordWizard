import SwiftUI

struct ContentView: View {
    @State private var unusedLetters = [Letter]()
    @State private var usedLetters = [Letter]()
    @State private var dictionary = Set<String>()
    
    @Namespace private var animation
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var time = 0
    @State private var score = 0
    @State private var usedWords = Set<String>()
    @State private var isGameOver = false
    
    @State private var currentLanguage: Language = .english
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("\(currentLanguage == .english ? "EN" : "TR")") {
                    switchLanguage()
                }
                .frame(width: 50, height: 50)
                .background(.blue).opacity(0.9)
                .clipShape(Circle())
                .padding()
                .foregroundStyle(.white)
                .font(.headline)
            }
            
            Spacer()
            
            HStack {
                ForEach(usedLetters) { letter in
                    LetterView(letter: letter, color: wordIsValid() ? .green : .red, onTap: remove)
                        .matchedGeometryEffect(id: letter, in: animation)
                }
            }
            
            Spacer()
            
            HStack {
                ForEach(unusedLetters) { letter in
                    LetterView(letter: letter, color: .yellow, onTap: add)
                        .matchedGeometryEffect(id: letter, in: animation)
                }
            }
            
            HStack {
                if dynamicTypeSize < .accessibility1 {
                    Spacer()
                }
                
                AnimatingNumberView(title: "Time", value: time)
                
                Spacer()
                
                Button("Go", action: submit)
                    .disabled(wordIsValid() == false)
                    .opacity(wordIsValid() ? 1 : 0.33)
                    .bold()
                
                Spacer()
                
                AnimatingNumberView(title: "Score", value: score)
                
                if dynamicTypeSize < .accessibility1 {
                    Spacer()
                }
            }
            .padding(.vertical, 5)
            .monospacedDigit()
            .font(.title)
            .foregroundStyle(.white)
        }
        .padding()
        .background(.blue.gradient)
        .onAppear(perform: {
            load()
        })
        .onReceive(timer, perform: { _ in
            if time == 0 {
                isGameOver = true
            } else {
                time -= 1
            }
        })
        .alert("Game over!", isPresented: $isGameOver) {
            Button("Play Again", action: newGame)
        } message: {
            Text("Your score was: \(score)")
        }
    }
    
    func load() {
        let fileName = currentLanguage == .english ? "dictionary" : "turkceKelimeler"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "txt") else { return }
        guard let contents = try? String(contentsOf: url) else { return }
        
        // Her kelimeyi temizleyin
        let cleanedWords = contents
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        
        dictionary = Set(cleanedWords)
        newGame()
    }
    
    func switchLanguage() {
        currentLanguage = currentLanguage == .english ? .turkish : .english
        load()
    }
    
    func add(_ letter: Letter) {
        guard let index = unusedLetters.firstIndex(of: letter) else { return }
        
        withAnimation(.spring) {
            unusedLetters.remove(at: index)
            usedLetters.append(letter)
        }
    }
    
    func remove(_ letter: Letter) {
        guard let index = usedLetters.firstIndex(of: letter) else { return }
        
        withAnimation(.spring) {
            usedLetters.remove(at: index)
            unusedLetters.append(letter)
        }
    }
    
    func wordIsValid() -> Bool {
        let word = usedLetters.map(\.character).joined().lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard usedWords.contains(word) == false else { return false }
        
        return dictionary.contains(word)
    }
    
    func newGame() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        isGameOver = false
        time = 30
        score = 0
        
        unusedLetters = (0..<9).map { _ in Letter(language: currentLanguage) }
        usedLetters.removeAll()
    }
    
    func submit() {
        guard wordIsValid() else { return }
        
        withAnimation {
            let word = usedLetters.map(\.character).joined().lowercased()
            usedWords.insert(word)
            
            score += usedLetters.count * usedLetters.count
            time += usedLetters.count * 2
            
            unusedLetters.append(contentsOf: (0..<usedLetters.count).map { _ in Letter(language: currentLanguage) })
            usedLetters.removeAll()
        }
    }
}

enum Language {
    case english, turkish
}

#Preview {
    ContentView()
}
