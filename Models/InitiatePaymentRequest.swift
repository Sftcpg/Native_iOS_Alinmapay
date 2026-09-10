//
//  InitiatePaymentRequest.swift
//  PaymentSDK
//
//  Created by Concerto on 26/06/26.
//

struct InitiatePaymentRequest: Codable {
  
    let terminalId: String
    let password: String

    let paymentType: String
    let currency: String
    let amount: String
    let referenceID: String
    let order: Order
    let customer: Customer
    let paymentInstrument: PaymentInstrument
    let additionalDetails: ReqAdditionalDetails
    let tokenization: Tokenization
    let merchantIP: String
    let customerIP: String
    let tokenizationType: String
    let signature: String
}
