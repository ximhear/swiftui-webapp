//
//  LoadingView.swift
//  webapp
//
//  Created by gzonelee on 6/13/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        }
        .frame(width: 120, height: 120)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

#Preview {
    LoadingView()
}
