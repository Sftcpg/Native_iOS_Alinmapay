//
//  SupportedPaymentMethod.swift
//  PaymentSDK
//
//  Created by Concerto on 17/07/26.
//

public struct SupportedPaymentMethodResponse: Codable {
    public let supportedPaymentModes: [String]
}

public struct SupportedPaymentMethodHeader: Codable {
    let terminalId: String
    let password: String
}
