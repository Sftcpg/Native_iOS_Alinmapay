//
//  SubmitPaymentResponse.swift
//  PaymentSDK
//
//  Created by Concerto on 02/07/26.
//
//
//public struct SubmitPaymentResponse: Codable {
//
//    // Present only for CHALLENGE response
//    public let threeDSChallengeResponse: ThreeDSChallengeResponse?
//
//    // Common fields
//    public let identifierFlag: String?
//    public let transactionId: String?
//    public let status: String?
//    
//    // Failure fields
//    public let responseCode: String?
//    public let responseDescription: String?
//    public let result: String?
//    public let orderDetails: OrderDetails?
//    public let amountDetails: AmountDetails?
//    public let cardDetails: SubmitCardDetails?
//    public let customerDetails: SubmitCustomerDetails?
//    
//    enum CodingKeys: String, CodingKey {
//        case threeDSChallengeResponse = "3dsChanllengeResponse"
//        case identifierFlag
//        case transactionId
//        case status
//    }
//}
//
//public struct ThreeDSChallengeResponse: Codable {
//
//    public let acsUrl: String
//    public let redirectHtml: String
//}
//
//  SubmitPaymentResponse.swift
//  PaymentSDK
//

import Foundation

public struct SubmitPaymentResponse: Codable {

    // MARK: Challenge Response

    public let threeDSChallengeResponse: ThreeDSChallengeResponse?

    // MARK: Common Response

    public let identifierFlag: String?
    public let transactionId: String?
    public let status: String?

    // MARK: Failure Response

    public let transactionDateTime: String?
    public let signature: String?
    public let terminalId: String?
    public let tokenization: SubmitTokenizationDetails?

    public let responseCode: String?
    public let responseDescription: String?
    public let result: String?

    public let orderDetails: SubmitOrderDetails?
    public let amountDetails: SubmitAmountDetails?
    public let cardDetails: SubmitCardDetails?
    public let customerDetails: SubmitCustomerDetails?
    public let additionalDetails: SubmitAdditionalDetails?

    public let paymentMethod: String?

    enum CodingKeys: String, CodingKey {

        case threeDSChallengeResponse = "3dsChanllengeResponse"

        case identifierFlag
        case transactionId
        case status

        case transactionDateTime
        case signature
        case terminalId
        case tokenization
        case responseCode
        case responseDescription
        case result

        case orderDetails
        case amountDetails
        case cardDetails
        case customerDetails
        case additionalDetails
        case paymentMethod
    }
}

// MARK: - 3DS Challenge

public struct ThreeDSChallengeResponse: Codable {

    public let acsUrl: String
    public let redirectHtml: String
}

// MARK: - Order

public struct SubmitOrderDetails: Codable {

    public let orderId: String?
}


// MARK: - Tokenization

public struct SubmitTokenizationDetails: Codable {

    public let cardToken: String?
}
// MARK: - Amount

public struct SubmitAmountDetails: Codable {

    public let amount: String?
    public let originalAmount: String?
}

// MARK: - Card

public struct SubmitCardDetails: Codable {

    public let maskedCard: String?
    public let cardBrand: String?
}

// MARK: - Customer

public struct SubmitCustomerDetails: Codable {

    public let cardHolderName: String?
}

// MARK: - Additional Details

public struct SubmitAdditionalDetails: Codable {

}
