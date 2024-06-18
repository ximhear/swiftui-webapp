//
//  LocalWebViewContainer.swift
//  webapp
//
//  Created by gzonelee on 6/14/24.
//

import SwiftUI

struct LocalWebViewContainer: View {
    @StateObject private var viewModel = WebViewViewModel(url: URL(string: "http://localhost:5173")!)
    @State var url: String = "http://localhost:5173"
//    @State var url: String = "http://192.168.0.34:8080"

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
            .padding(.bottom, 4)
            .background(.purple.opacity(0.3))

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
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
            .background(.purple.opacity(0.3))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    WebViewContainer()
}
