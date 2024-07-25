//
//  AnimatingNumberView.swift
//  WordWizard
//
//  Created by Günseli Ünsal on 25.07.2024.
//

import SwiftUI

struct AnimatingNumberView: View, Animatable {
    var title: String
    var value: Int

    var animatableData: Double {
        get { Double(value) }
        set { value = Int(newValue) }
    }

    var body: some View {
        Text("\(title): \(value)")
    }
}

#Preview {
    AnimatingNumberView(title: "Score", value: 0)
}
