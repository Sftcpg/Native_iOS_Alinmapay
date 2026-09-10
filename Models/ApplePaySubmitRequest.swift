//
//  ApplePaySubmitRequest.swift
//  PaymentSDK
//
//  Created by Concerto on 07/09/26.
//

struct ApplePaySubmitRequest: Codable {

    let terminalId: String
    let paymentInstrument: ApplePayPaymentInstrument
    let PaymentToken: ApplePayPaymentToken
    let amount: String
    let signature: String
    let tokenization: ApplePayTokenization
    let additionalDetails: ApplePayAdditionalDetails
    let deviceInfo: ApplePayDeviceInfo
    let customer: ApplePayCustomer
    let password: String
    let merchantIp: String
    let currency: String
    let customerIp: String
    let paymentType: String
    let order: ApplePayOrder

    enum CodingKeys: String, CodingKey {
        case terminalId
        case paymentInstrument
        case PaymentToken = "PaymentToken"
        case amount
        case signature
        case tokenization
        case additionalDetails
        case deviceInfo
        case customer
        case password
        case merchantIp
        case currency
        case customerIp
        case paymentType
        case order
    }
}
struct ApplePayPaymentToken: Codable {

    let paymentMethod: ApplePayTokenPaymentMethod
    let paymentData: String
    let transactionIdentifier: String
}
struct ApplePayPaymentInstrument: Codable {

    let paymentMethod: String
}
struct ApplePayTokenPaymentMethod: Codable {

    let displayName: String
    let network: String
    let type: String
}
struct ApplePayTokenization: Codable {

    let tokenizationType: String
    let cardToken: String
    let operation: String
}
struct ApplePayOrder: Codable {

    let orderId: String
    let description: String
}

struct ApplePayCustomer: Codable {

    let billingAddressStreet: String
    let billingAddressState: String
    let billingAddressPostalCode: String
    let billingAddressCity: String
    let billingAddressCountry: String
    let customerEmail: String
}

struct ApplePayAdditionalDetails: Codable {

    let userData: String
}
struct ApplePayDeviceInfo: Codable {

    let deviceModel: String
    let pluginVersion: String
    let clientPlatform: String
    let devicePlatform: String
    let deviceOSVersion: String
    let pluginName: String
}
