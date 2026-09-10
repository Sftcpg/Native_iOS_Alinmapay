//
//  SDKLabelField.swift
//  PaymentSDK
//
//  Created by Concerto on 03/09/26.
//

import SwiftUI
public struct SDKLabelField: View
{
    private let title: String
    private let width: CGFloat?
    private let textStyle: SDKTextStyle
   

    public init(
         title: String,
         textStyle: SDKTextStyle? = nil,
         width: CGFloat? = nil
     ) {
         self.title = title
         self.textStyle =
             textStyle
             ?? SDKThemeManager.shared.theme.labelStyle
         self.width = width
     }

     public var body: some View {

         Text(title)
           
             .fontWeight(
                 textStyle.isBold
                 ? .bold
                 : .regular
             )
             .foregroundColor(textStyle.color)
             .frame(
                 width: width,
                 height: textStyle.height,
                 alignment: .center
             )
     }
 }
    
    
