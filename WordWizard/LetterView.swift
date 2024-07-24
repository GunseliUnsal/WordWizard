//
//  LetterView.swift
//  WordWizard
//
//  Created by Günseli Ünsal on 24.07.2024.
//

import SwiftUI

struct LetterView: View {
    let letter: Letter
    var onTap: (Letter) -> Void
    
    var body: some View {
        Button(action: {
            onTap(letter)
        }, label: {
            Text(letter.character)
                .foregroundStyle(.black).opacity(0.65)
                .font(.largeTitle.bold())
        })
    }
}

#Preview {
    LetterView(letter: Letter()) {_ in}
}
