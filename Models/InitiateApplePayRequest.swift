//
//  InitiateApplePayRequest.swift
//  PaymentSDK
//
//  Created by Concerto on 07/09/26.
//


struct InitiateApplePayRequest: Codable {
    
    let terminalId: String
    let password: String
    let paymentType: String
    let currency: String
    let amount: String
    let referenceID: String
    let order: Order
    let customer: Customer
    let merchantIP: String
    let customerIP: String
    let paymentInstrument: PaymentInstrument
    let paymentToken: PaymentToken
    let additionalDetails: ReqAdditionalDetails
    let tokenization: Tokenization
    let deviceInfo: DeviceInfo
    let signature: String
    
}
