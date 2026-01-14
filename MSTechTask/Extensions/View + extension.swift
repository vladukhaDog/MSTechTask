//
//  View + extension.swift
//  MSTechTask
//
//  Created by Владислав Пермяков on 14.01.2026.
//


import SwiftUI

struct LoadingIndicatorModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        content
            .disabled(isLoading)
            .blur(radius: isLoading ? 1 : 0)
            .overlay {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
    }
}
extension View {
    func loadingIndicator(_ isLoading: Bool) -> some View {
        modifier(LoadingIndicatorModifier(isLoading: isLoading))
    }
}


#Preview {
    Text("Lorem ipsum")
        .loadingIndicator(true)
}
