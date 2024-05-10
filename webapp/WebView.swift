//
//  WebView.swift
//  webapp
//
//  Created by gzonelee on 5/10/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewViewModel

    func makeUIView(context: Context) -> WKWebView {
        return viewModel.webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // WebView 업데이트 로직이 필요하지 않을 때 이 부분은 비워둘 수 있습니다.
    }
}
