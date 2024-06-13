//
//  LoadingTest.swift
//  webapp
//
//  Created by gzonelee on 6/13/24.
//

import SwiftUI

struct LoadingTest: View {
    var body: some View {
        VStack {
            Button {
                Loading.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    Loading.hide()
                }
            } label: {
                Text("Show")
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    LoadingTest()
}
