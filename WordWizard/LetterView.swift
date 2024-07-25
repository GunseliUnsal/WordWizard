//
//  LetterView.swift
//  WordWizard
//
//  Created by Günseli Ünsal on 24.07.2024.
//

import SwiftUI

struct LetterView: View {
    @ScaledMetric(relativeTo: .largeTitle) var size = 60
    
    let letter: Letter
    var color: Color
    var onTap: (Letter) -> Void
    
    var body: some View {
        Button {
            onTap(letter)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.gradient)
                    .frame(height: size)
                    .frame(minWidth: size / 2, maxWidth: size)
                    .shadow(radius: 3)

                Text(letter.character)
                    .foregroundColor(.black.opacity(0.65))
                    .font(.largeTitle.bold())
            }
        }
        .accessibilityLabel(letter.character.lowercased())
    }
}

#Preview {
    LetterView(letter: Letter(language: .english), color: .green) {_ in}
}
