//
//  SDKTheme.swift
//  PaymentSDK
//
//  Created by Concerto on 18/06/26.
//

//
//  SDKTheme.swift
//  PaymentSDK
//

import SwiftUI
import UIKit

public struct SDKTheme {

    // MARK: Colors
    public var primaryColor: Color
    public var textColor: Color
    public var buttonTextColor: Color


    // MARK: Branding
    public var merchantBranding: SDKMerchantBranding
    public var logo: UIImage?

    // MARK: Typography

    public var font: Font

    // MARK: UI Styling

    public var buttonCornerRadius: CGFloat

    public var primaryButtonStyle: SDKButtonStyle

    public var labelStyle: SDKTextStyle
    public var inputStyle: SDKInputStyle

    // MARK: Initializer

    public init(
        primaryColor: Color = .blue,
        merchantBranding: SDKMerchantBranding = .none(),
        backgroundColor: Color = .white,
        textColor: Color = .black,
        buttonTextColor: Color = .white,
        borderColor: Color = Color.gray.opacity(0.3),
        errorColor: Color = .red,
        successColor: Color = .green,
        logo: UIImage? = nil,
        font: Font = .body,
        buttonCornerRadius: CGFloat = 12,
        textFieldCornerRadius: CGFloat = 10,
    
        primaryButtonStyle: SDKButtonStyle = SDKButtonStyle(),


        labelStyle: SDKTextStyle = SDKTextStyle(
            color: .gray,
            height: 20,
            isBold: false ),
        

        inputStyle: SDKInputStyle = SDKInputStyle(
            backgroundColor: .white,
            borderColor: .gray,
            borderWidth: 1,
            cornerRadius: 5
        ),
    )
    
    {
        self.primaryColor = primaryColor
        self.merchantBranding = merchantBranding
        self.textColor = textColor
        self.buttonTextColor = buttonTextColor
     
        self.logo = logo
        self.font = font
        self.buttonCornerRadius = buttonCornerRadius
     
        self.primaryButtonStyle = primaryButtonStyle
        self.inputStyle = inputStyle
        self.labelStyle = labelStyle
      //self.valueTextStyle = valueTextStyle
    }
}

extension SDKTheme {

    public static var light: SDKTheme {
        SDKTheme(
            primaryColor: .blue,
          
            backgroundColor: .white,
            textColor: .black,
            buttonTextColor: .white,
            borderColor: .gray.opacity(0.7),
            errorColor: .red,
            successColor: .green,
            font: .body,
            buttonCornerRadius: 12,
            textFieldCornerRadius: 10
        )
    }
    
    public static var dark: SDKTheme {
           SDKTheme(
               primaryColor: .blue,
            
               backgroundColor: .black,
               textColor: .white,
               buttonTextColor: .white,
               borderColor: .gray,
               errorColor: .red,
               successColor: .green,
               font: .body,
               buttonCornerRadius: 12,
               textFieldCornerRadius: 10
           )
       }
}
