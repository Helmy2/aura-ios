//
//  SearchBarView.swift
//  iosApp
//
//  Created by platinum on 29/12/2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var isSearchActive: Bool
    var onSearch: () -> Void
    var onClear: () -> Void

    var body: some View {
        HStack {
            if isSearchActive {
                Button(action: onClear) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .transition(.move(edge: .leading).combined(with: .opacity))
            }

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search wallpapers...", text: $text)
                    .submitLabel(.search)
                    .onSubmit {
                        onSearch()
                    }

                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .animation(.default, value: isSearchActive)
    }
}
