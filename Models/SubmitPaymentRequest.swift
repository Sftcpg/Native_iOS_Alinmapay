//
//  SubmitPaymentRequest.swift
//  PaymentSDK
//
//  Created by Concerto on 02/07/26.
//

import Foundation

public struct SubmitPaymentRequest: Codable {

    public let referenceId: String
    public let customerIp: String
    public let amount: String
    public let currency: String
    public let cardTokenFlag: String
    
    public let paymentInstrument: SubmitPaymentInstrument
    public let card: Card
    public let customer: SubmitCustomer
    public let browserDetails: BrowserDetails
}

public struct SubmitPaymentInstrument: Codable {

    public let vpaId: String?
    public let walletId: String?
    public let paymentMethod: String
    public let channelName: String?
}

public struct Card: Codable {

    public let number: String?
    public let cvv: String
    public let expiryMonth: String?
    public let expiryYear: String?
}

public struct SubmitCustomer: Codable {

    public let cardHolderName: String
    public let customerEmail: String
}

public struct BrowserDetails: Codable {

    public let transactionUuid: String
    public let browserLanguage: String
    public let browserScreenHeight: String
    public let browserJavascriptEnabled: Bool
    public let browserColorDepth: String
    public let browserJavaEnabled: Bool
    public let browserScreenWidth: String
    public let browserAcceptHeader: String
    public let browserTZ: String
    public let browserUserAgent: String
}
