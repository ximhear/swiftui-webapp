//
//  Popup.swift
//  webapp
//
//  Created by gzonelee on 6/13/24.
//

import SwiftUI

struct Popup: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return PopupOverlay.shared
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No need to update the view
    }

    static func show<Title: View, Body: View>(
        @ViewBuilder title: () -> Title,
        @ViewBuilder bodyContent: () -> Body,
        buttons: [PopupButton],
        buttonAction: @escaping (PopupButton) -> Void
    ) {
        PopupOverlay.shared.show(
            title: title(),
            bodyContent: bodyContent(),
            buttons: buttons,
            buttonAction: buttonAction
        )
    }

    static func hide() {
        PopupOverlay.shared.hide()
    }
}

