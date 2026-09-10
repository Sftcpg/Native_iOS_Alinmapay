//
//  SDKInputStyle.swift
//  PaymentSDK
//
//  Created by Concerto on 03/09/26.
//

import SwiftUI

public struct SDKInputStyle {

    public var backgroundColor: Color
    public var borderColor: Color
    public var borderWidth: CGFloat
    public var cornerRadius: CGFloat

    public init(
        backgroundColor: Color = .white,
        borderColor: Color = .gray,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 5
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
    }
}

