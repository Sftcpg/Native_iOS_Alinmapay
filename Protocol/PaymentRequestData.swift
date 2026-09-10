//
//  PaymentRequestData.swift
//  PaymentSDK
//
//  Created by Concerto on 08/07/26.
//

//
//  PaymentRequest.swift
//  PaymentSDK
//

import Foundation

public struct PaymentRequestData {

    public let amount: String
    public let transactionType: String
    public let currency: String
    public let email: String
    public let address: String
    public let city: String
    public let state: String
    public let zip: String
    public let countryCode: String
    public let trackId: String
    public let cardOperation: String
    public let cardToken: String
    public let tokenType: String
    public let transactionId: String
    public let metadata: String

    public init(
        amount: String = "",
        transactionType: String = "",
        currency: String = "",
        email: String = "",
        address: String = "",
        city: String = "",
        state: String = "",
        zip: String = "",
        countryCode: String = "",
        trackId: String = "",
        cardOperation: String = "",
        cardToken: String = "",
        tokenType: String = "0",
        transactionId: String = "",
        metadata: String = "{}"
    ) {
        self.amount = amount
        self.transactionType = transactionType
        self.currency = currency
        self.email = email
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.countryCode = countryCode
        self.trackId = trackId
        self.cardOperation = cardOperation
        self.cardToken = cardToken
        self.tokenType = tokenType
        self.transactionId = transactionId
        self.metadata = metadata
    }
}
