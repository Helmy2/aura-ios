//
//  FavoriteButton.swift
//  iosApp
//
//  Created by platinum on 27/12/2025.
//

import SwiftUI


struct FavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void

    @State private var isAnimating = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isAnimating = true
            }
            action()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = false
            }
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 20))
                .foregroundStyle(isFavorite ? .red : .white)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
                .scaleEffect(isAnimating ? 1.2 : 1.0)
        }
    }
}
