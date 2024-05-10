//
//  WebViewContainer.swift
//  webapp
//
//  Created by gzonelee on 5/10/24.
//

import SwiftUI

struct WebViewContainer: View {
    @StateObject private var viewModel = WebViewViewModel(url: URL(string: "https://www.daum.net")!)
    @State var url: String = "https://www.daum.net"

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                TextField("URL", text: $url)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(4)
                Button {
                    viewModel.commandPublisher.send(.gotoUrl(URL(string: url)!))
                } label: {
                    Text("Go")
                }
                .buttonStyle(WButtonStyle())
                .disabled(url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal)
            
            WebView(viewModel: viewModel)
            VStack {
                HStack {
                    Button("Go Back") {
                        viewModel.commandPublisher.send(.goBack)
                    }
                    .buttonStyle(WButtonStyle())
                    Button("Go Forward") {
                        viewModel.commandPublisher.send(.goForward)
                    }
                    .buttonStyle(WButtonStyle())
                }
                Button("Reload") {
                    viewModel.commandPublisher.send(.reload)
                }
                .buttonStyle(WButtonStyle())
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    WebViewContainer()
}
