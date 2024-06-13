//
//  PopupTest.swift
//  webapp
//
//  Created by gzonelee on 6/13/24.
//

import SwiftUI

struct PopupTest: View {
    var body: some View {
        VStack {
            Button {
                show()
            } label: {
                Text("Show")
            }
            .buttonStyle(.bordered)
        }
    }
    
    private func show() {
        Popup.show(title: {
            Text("Title")
        }, bodyContent: {
            Text("안녕하세요\nBody입니다. sdjflsd jls jsdlf jlsdfj lsdjfl sdjlfj sdlfj sldjf lsdjfl jsdlfj sdlfj sdldjflsdjflsdjflsdjfljsdlfjsdlfjsldfjlsjflsfj")
        }, buttons: [.cancel, .delete, .ok]) { button in
            GZLogFunc(button)
        }
    }
}

#Preview {
    PopupTest()
}
