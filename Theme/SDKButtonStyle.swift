//
//  SDKButtonStyle.swift
//  PaymentSDK
//
//  Created by Concerto on 08/07/26.
//

import SwiftUI

public struct SDKButtonStyle {

    public var backgroundColor: Color
    public var textColor: Color
    public var cornerRadius: CGFloat
    public var borderColor: Color
    public var borderWidth: CGFloat
    public var font: Font
    public var height: CGFloat

    public init(
        backgroundColor: Color = .blue,
        textColor: Color = .white,
        cornerRadius: CGFloat = 12,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        font: Font = .headline,
        height: CGFloat = 50
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.font = font
        self.height = height
    }
}
