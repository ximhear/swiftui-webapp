//
//  WebViewViewModel.swift
//  webapp
//
//  Created by gzonelee on 5/10/24.
//

import Foundation
import WebKit
import Combine

class WeakWKScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

class WebViewViewModel: NSObject, ObservableObject, WKNavigationDelegate, WKScriptMessageHandler {
    @Published var webView: WKWebView
    private var cancellables: Set<AnyCancellable> = []

    // 커맨드를 수신할 수 있는 Publisher
    let commandPublisher = PassthroughSubject<WebViewCommand, Never>()

    // 초기 URL
    var initialURL: URL

    init(url: URL) {
        self.initialURL = url

        // 웹뷰 설정
        let configuration = WKWebViewConfiguration()
//        configuration.preferences.javaScriptEnabled = true
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let contentController = WKUserContentController()
        configuration.userContentController = contentController
        
        // make inspect possible

        self.webView = WKWebView(frame: .zero, configuration: configuration)
        super.init()
        
        if #available(iOS 16.4, *) {
            self.webView.isInspectable = true
        }

        contentController.add(WeakWKScriptMessageHandler(delegate: self), name: "jsToSwift")
        self.webView.navigationDelegate = self

        // 초기 URL 로드
        loadInitialURL()

        // 커맨드에 따라 동작 수행
        commandPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] command in
                guard let self = self else { return }
                switch command {
                case .goBack:
                    if self.webView.canGoBack {
                        self.webView.goBack()
                    }
                case .goForward:
                    if self.webView.canGoForward {
                        self.webView.goForward()
                    }
                case .reload:
                    self.webView.reload()
                case .gotoUrl(let url):
                    self.loadURL(url)
                }
            }
            .store(in: &cancellables)
    }

    func loadInitialURL() {
        loadURL(initialURL)
    }

    private func loadURL(_ url: URL) {
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsToSwift", let messageBody = message.body as? String {
            print("Received message from JS: \(messageBody)")
            // Handle the message or notify SwiftUI view here
        }
    }

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "jsToSwift")
    }
}

enum WebViewCommand {
    case goBack
    case goForward
    case reload
    case gotoUrl(URL)
}
