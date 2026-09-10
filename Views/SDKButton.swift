//
//  SDKButton.swift
//  PaymentSDK
//
//  Created by Concerto on 08/07/26.
//

import SwiftUI
public struct SDKButton: View {

    let title: String
    let systemImage: String?
    let style: SDKButtonStyle
    let action: () -> Void

    public init(
        title: String,
        systemImage: String? = nil,
        style: SDKButtonStyle,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.style = style
        self.action = action
    }

    public var body: some View {

        Button(action: action) {

            HStack(spacing: 8) {

                         if let systemImage {

                             Image(systemName: systemImage)
                         }

                         Text(title)
                     }
                .font(style.font)
                .foregroundColor(style.textColor)
                .frame(maxWidth: .infinity)
                .frame(height: style.height)
                .background(style.backgroundColor)
                .cornerRadius(style.cornerRadius)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: style.cornerRadius
                    )
                    .stroke(
                        style.borderColor,
                        lineWidth: style.borderWidth
                    )
                )
        }
    }
}
