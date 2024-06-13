//
//  KeyChainTest.swift
//  webapp
//
//  Created by gzonelee on 6/13/24.
//

import SwiftUI

struct KeyChainTest: View {
    @State var value: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Value:")
                Text(value)
            }
            HStack {
                TextField("Enter value", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    KeychainService.shared.saveToken(token: value, forKey: "test")
                } label: {
                    Text("Save")
                }
                .buttonStyle(.bordered)
            }
            Button {
                load()
            } label: {
                Text("Reload")
            }
            .buttonStyle(.bordered)
            Button {
                KeychainService.shared.deleteToken(forKey: "test")
                load()
            } label: {
                Text("Delete")
            }
            .buttonStyle(.bordered)
            Button {
                KeychainService.shared.deleteAllTokens()
                load()
            } label: {
                Text("Delete All")
            }
            .buttonStyle(.bordered)
            .disabled(value.trim().isEmpty)
        }
        .padding()
        .onAppear {
            load()
        }
        .navigationTitle("KeyChain Test")
    }
    
    private func load() {
        value = KeychainService.shared.getToken(forKey: "test") ?? "--xx--"
    }
}

#Preview {
    KeyChainTest()
}

// trim()
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
