//
//  PopupButton.swift
//  webapp
//
//  Created by gzonelee on 6/13/24.
//

import SwiftUI

enum PopupButton {
    case ok
    case cancel
    case delete

    var title: String {
        switch self {
        case .ok: return "OK"
        case .cancel: return "Cancel"
        case .delete: return "Delete"
        }
    }
}

