//
//  InitiateApplePay.swift
//  PaymentSDK
//
//  Created by Concerto on 08/09/26.
//


struct InitiateApplePay: Codable {
    
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
    let PaymentToken: String
    let additionalDetails: ReqAdditionalDetails
    let tokenization: Tokenization
    let deviceInfo: DeviceInfo
    let signature: String
    
}
