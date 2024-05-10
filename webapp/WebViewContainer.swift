//
//  WebViewContainer.swift
//  webapp
//
//  Created by gzonelee on 5/10/24.
//

import SwiftUI

struct WebViewContainer: View {
    @StateObject private var viewModel = WebViewViewModel(url: URL(string: "https://www.daum.net")!)

    var body: some View {
        VStack {
            WebView(viewModel: viewModel)
            HStack {
                Button("Go Back") {
                    viewModel.commandPublisher.send(.goBack)
                }
                Button("Go Forward") {
                    viewModel.commandPublisher.send(.goForward)
                }
                Button("Reload") {
                    viewModel.commandPublisher.send(.reload)
                }
            }
        }
    }
}

#Preview {
    WebViewContainer()
}
