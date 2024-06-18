//
//  WebViewViewModel.swift
//  webapp
//
//  Created by gzonelee on 5/10/24.
//

import Foundation
import WebKit
import Combine
import PhotosUI

class WeakWKScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

class WebViewViewModel: NSObject, ObservableObject, WKNavigationDelegate, WKScriptMessageHandler, UINavigationControllerDelegate {
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
        GZLogFunc("didReceive message: \(message.name)")
        GZLogFunc("didReceive message: \(message.body)")
        GZLogFunc("didReceive message: \(type(of: message.body))")
        
        if message.name == "jsToSwift", let messageBody = message.body as? Dictionary<String, Any> {
            GZLogFunc(messageBody)
            do {
                // JSONSerialization을 사용하여 Dictionary를 Data로 변환
                let jsonData = try JSONSerialization.data(withJSONObject: messageBody, options: [])
                
                // JSONDecoder를 사용하여 Data를 Decodable 객체로 변환
                let decoder = JSONDecoder()
                let body = try decoder.decode(ScriptMessageBody.self, from: jsonData)
                if body.type == "getAccessToken" {
                    let value = KeychainService.shared.getToken(forKey: "test")
                    GZLogFunc(value)
                    let script = "window.setAccessToken('\(value ?? "")')"
                    GZLogFunc(script)
                    webView.evaluateJavaScript(script)
                }
                else if body.type == "saveAccessToken" {
                    let body = try decoder.decode(SaveAccessTokenBody.self, from: jsonData)
                    KeychainService.shared.saveToken(token: body.value, forKey: "test")
                }
                else if body.type == "takePhoto" {
                    presentImagePicker(sourceType: .camera)
                }
                else if body.type == "pickPhoto" {
                    presentPHPicker()
                }
            } catch {
                GZLogFunc("Failed to decode message body: \(error)")
            }
        }
    }

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "jsToSwift")
    }
    
    private func presentPHPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker)
    }
    
    func present(_ viewController: UIViewController) {
        // 현재 뷰 컨트롤러를 가져와서 UIImagePickerController를 표시
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topController = windowScene.windows.first?.rootViewController {
            topController.present(viewController, animated: true, completion: nil)
        }
    }
    
    func handleImageSelected(_ image: UIImage) {
        // 이미지가 선택되었을 때의 처리 로직
        guard let imageData = image.pngData() else { return }
        let base64String = imageData.base64EncodedString()
        let jsCode = "displayImage('data:image/png;base64,\(base64String)')"
        
        webView.evaluateJavaScript(jsCode, completionHandler: { (result, error) in
            if let error = error {
                GZLogFunc("Error executing JavaScript: \(error)")
            } else {
                GZLogFunc("JavaScript executed successfully")
            }
        })
    }
}

extension WebViewViewModel: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            // 사진이 선택되거나 찍혔을 때의 처리 로직
            handleImageSelected(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

extension WebViewViewModel: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
            if let image = object as? UIImage {
                DispatchQueue.main.async {[weak self] in
                    self?.handleImageSelected(image)
                }
            }
        }
    }
}

enum WebViewCommand {
    case goBack
    case goForward
    case reload
    case gotoUrl(URL)
}

struct ScriptMessageBody: Decodable {
    let type: String
}

struct SaveAccessTokenBody: Decodable {
    let value: String
}
