//
//  WebView2Container.swift
//  webapp
//
//  Created by gzonelee on 5/10/24.
//

import SwiftUI

struct WebView2Container: View {
    @StateObject private var ssr = WebViewViewModel(url: URL(string: "https://naver.com/")!)
    @StateObject private var csr = WebViewViewModel(url: URL(string: "https://naver.com/")!)

    var body: some View {
        VStack {
            WebView(viewModel: ssr)
            WebView(viewModel: csr)
            HStack {
                Group {
                    Button {
                        csr.commandPublisher.send(.gotoUrl(URL(string: "https://nuxt3test-csr.vercel.app/")!))
                        ssr.commandPublisher.send(.gotoUrl(URL(string: "https://nuxt3test-ssr.vercel.app/")!))
                    } label: {
                        Text("Go to")
                    }
                    Button {
                        ssr.commandPublisher.send(.reload)
                        csr.commandPublisher.send(.reload)
                    } label: {
                        Text("Reload")
                    }
                }
                .buttonStyle(WButtonStyle())
            }
            Divider()
                .background(.clear)
        }
    }
}

#Preview {
    WebView2Container()
}
