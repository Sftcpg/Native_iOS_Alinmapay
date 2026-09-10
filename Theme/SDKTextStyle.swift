//
//  SDKTextStyle.swift
//  PaymentSDK
//
//  Created by Concerto on 08/07/26.
//

import SwiftUI

public struct SDKTextStyle {

    //public var font: Font
    public var color: Color
    public var height: CGFloat
    public var isBold: Bool

    public init(
       // font: Font = .body,
        color: Color = .black,
        height: CGFloat = 20,
        isBold: Bool = false
    ) {
       // self.font = font
        self.color = color
        self.height = height
        self.isBold = isBold
    }
}
