//
//  MessageBoxView.swift
//  webapp
//
//  Created by gzonelee on 6/13/24.
//

import SwiftUI

struct MessageBoxView<Title: View, Body: View>: View {
    let title: Title
    let bodyContent: Body
    let buttons: [PopupButton]
    let buttonAction: (PopupButton) -> Void
    
    init(title: Title, bodyContent: Body, buttons: [PopupButton], buttonAction:@escaping (PopupButton) -> Void) {
        self.title = title
        self.bodyContent = bodyContent
        self.buttons = buttons
        self.buttonAction = buttonAction
    }

    var body: some View {
        VStack(spacing: 20) {
            title
            bodyContent
            HStack {
                ForEach(0..<buttons.count, id: \.self) { index in
                    Button(action: {
                        buttonAction(buttons[index])
                    }) {
                        Text(buttons[index].title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

