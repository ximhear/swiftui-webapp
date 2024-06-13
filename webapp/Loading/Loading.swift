//
//  Loading.swift
//  webapp
//
//  Created by gzonelee on 6/13/24.
//

import SwiftUI
import UIKit

class LoadingOverlay: UIView {
    private var count = 0
    private var hostingController: UIHostingController<LoadingView>?

    static let shared = LoadingOverlay()

    private init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.isUserInteractionEnabled = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let loadingView = LoadingView()
        hostingController = UIHostingController(rootView: loadingView)
        if let hostingView = hostingController?.view {
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(hostingView)
            NSLayoutConstraint.activate([
                hostingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                hostingView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//                hostingView.widthAnchor.constraint(equalToConstant: 120),
//                hostingView.heightAnchor.constraint(equalToConstant: 120)
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        DispatchQueue.main.async {
            self.count += 1
            if self.count == 1 {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.addSubview(self)
                }
            }
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.count -= 1
            if self.count == 0 {
                self.removeFromSuperview()
            }
        }
    }
}

struct Loading: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return LoadingOverlay.shared
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No need to update the view
    }

    static func show() {
        LoadingOverlay.shared.show()
    }

    static func hide() {
        LoadingOverlay.shared.hide()
    }
}
