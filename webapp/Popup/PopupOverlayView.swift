//
//  PopupOverlayView.swift
//  webapp
//
//  Created by gzonelee on 6/13/24.
//

import UIKit
import SwiftUI

class PopupOverlay: UIView {
    private var hostingController: UIHostingController<AnyView>?

    static let shared = PopupOverlay()

    private init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.isUserInteractionEnabled = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.alpha = 0 // 초기에는 투명하게 설정
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show<Title: View, Body: View>(title: Title, bodyContent: Body, buttons: [PopupButton], buttonAction: @escaping (PopupButton) -> Void) {
        DispatchQueue.main.async {
            let messageBoxView = MessageBoxView(title: title,
                                                bodyContent: bodyContent,
                                                buttons: buttons,
                                                buttonAction: { button in
                buttonAction(button)
                self.hide()
            })
            self.hostingController = UIHostingController(rootView: AnyView(messageBoxView))
            
            if let hostingView = self.hostingController?.view {
                hostingView.translatesAutoresizingMaskIntoConstraints = false
                hostingView.backgroundColor = .clear
                self.addSubview(hostingView)
                NSLayoutConstraint.activate([
                    hostingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    hostingView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    hostingView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.8),
                    hostingView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.8)
                ])
            }
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.addSubview(self)
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1
                }
            }
        }
    }

    func hide() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { _ in
                self.hostingController?.view.removeFromSuperview()
                self.hostingController = nil
                self.removeFromSuperview()
            }
        }
    }
}

