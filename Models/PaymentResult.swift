//
//  PaymentResult.swift
//  PaymentSDK
//
//  Created by Concerto on 06/07/26.
//

import Foundation

public struct PaymentResult: Codable {

    public let transactionId: String?
    public let transactionDateTime: String?

    public let result: String?
    public let responseCode: String?
    public let responseDescription: String?

    public let orderId: String?
    public let amount: String?
    public let originalAmount: String?

    public let paymentMethod: String?

    public let maskedCard: String?
    public let cardBrand: String?
    public let cardToken: String?

    public let cardHolderName: String?

    public let signature: String?
    public let terminalId: String?
    public let rawJson: String?
    public init(
        
        rawJson: String?,
        
        transactionId: String?,
        transactionDateTime: String?,
        result: String?,
        responseCode: String?,
        responseDescription: String?,
        orderId: String?,
        amount: String?,
        originalAmount: String?,
        paymentMethod: String?,
        maskedCard: String?,
        cardBrand: String?,
        cardToken: String?,
        cardHolderName: String?,
        signature: String?,
        terminalId: String?
    ) {
        self.rawJson = rawJson
        
        self.transactionId = transactionId
        self.transactionDateTime = transactionDateTime
        self.result = result
        self.responseCode = responseCode
        self.responseDescription = responseDescription
        self.orderId = orderId
        self.amount = amount
        self.originalAmount = originalAmount
        self.paymentMethod = paymentMethod
        self.maskedCard = maskedCard
        self.cardBrand = cardBrand
        self.cardToken = cardToken
        self.cardHolderName = cardHolderName
        self.signature = signature
        self.terminalId = terminalId
    }
}
