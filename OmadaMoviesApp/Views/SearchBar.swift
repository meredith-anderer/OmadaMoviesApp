//
//  SearchBar.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundStyle(.gray)
            TextField("Search", text: $text)
            
            if !text.isEmpty {
                Image(systemName: "xmark.circle.fill").foregroundStyle(.gray).onTapGesture {
                    text = ""
                }
            }
        }
        .padding(8)
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(8)

    }
}
