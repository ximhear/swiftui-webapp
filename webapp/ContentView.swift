//
//  ContentView.swift
//  webapp
//
//  Created by gzonelee on 5/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    WebViewContainer()
                } label: {
                    Text("web")
                        .font(.title)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink {
                    WebViewContainer()
                } label: {
                    Text("web")
                        .font(.title)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink {
                    KeyChainTest()
                } label: {
                    Text("KeyChain")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink {
                    LoadingTest()
                } label: {
                    Text("Loading Test")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink {
                    PopupTest()
                } label: {
                    Text("Popup Test")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .listStyle(.plain)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
