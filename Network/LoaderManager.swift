//
//  LoaderManager.swift
//  PaymentSDK
//
//  Created by Concerto on 10/07/26.
//

import SwiftUI
internal import Combine

final class LoaderManager: ObservableObject {

    static let shared = LoaderManager()

    @Published var isLoading = false

    private init() {}

    func show() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}

struct LoaderView: View {

    var body: some View {

        ZStack {

            Color.black.opacity(0.4)
                .ignoresSafeArea()

            ProgressView("Please wait...")
                .padding(20)
                .background(Color.white)
                .cornerRadius(15)
        }
    }
}
