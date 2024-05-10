//
//  WButtonStyle.swift
//  webapp
//
//  Created by gzonelee on 5/10/24.
//

import Foundation
import SwiftUI

struct WButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
